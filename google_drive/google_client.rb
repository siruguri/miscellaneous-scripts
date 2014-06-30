require 'fileutils'
require 'open-uri'
require 'time'

require 'rubygems'
# require 'google-contacts'

require 'parseconfig'
require 'google/api_client'
require 'launchy'

class GoogleBackup
  class NoKnownFormat < Exception
  end
  class UnknownMimeType < Exception
  end

  def initialize(config, destination_folder:nil, client:nil)
    @known_conversions = {'text/tab-separated-values' => 'tsv', 'application/pdf' => 'pdf', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' => 'xls', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' => 'docx', 'text/plain' => 'txt', 'application/msword' => 'doc', "application/vnd.oasis.opendocument.text" => "odt"}
    @destination_folder = "."

    @config = config
    if destination_folder
      @destination_folder = File.join @destination_folder, destination_folder
    elsif @config['target_directory']
      @destination_folder = File.join @destination_folder, @config['target_directory']
    end

    if !Dir.exist? @destination_folder
      Dir.mkdir @destination_folder
    end

    log("Starting backups into #{@destination_folder}")

    if client
      @client=client
    else
      @client = Google::APIClient.new(application_name: "Drive Reader", application_version: "0.9")
      # OAUTH_SCOPE = 'https://www.googleapis.com/auth/contacts'
      @config.add('oauth_scope', 'https://www.googleapis.com/auth/drive')
      @config.add('redirect_uri', 'urn:ietf:wg:oauth:2.0:oob')

      @client.authorization.client_id = @config['client_id']
      @client.authorization.client_secret = @config['client_secret']
      @client.authorization.scope = @config['oauth_scope']
      @client.authorization.redirect_uri = @config['redirect_uri']
    end
    @drive = @client.discovered_api('drive', 'v2')
  end

  def do_authorization()
    if @config['oauth_creds'].nil?
      self.request_authorization(client)
      puts creds.class
      puts creds
    else
      creds = @config['oauth_creds']
      puts ">> From file: #{creds}"
  
      @client.authorization.access_token=creds['access_token']
      @client.authorization.refresh_token=creds['refresh_token']
      @client.authorization.grant_type = 'refresh_token'
    end
    @client.authorization.fetch_access_token!
  end

  def insert_file(filename)
    # load the Google Drive API
    file = @drive.files.insert.request_schema.new({
                                                   'title' => filename,
                                                   'description' => 'A test document',
                                                   'mimeType' => 'text/plain'
                                                 })
    media = Google::APIClient::UploadIO.new(filename, 'text/plain')
    result = @client.execute(
                             :api_method => @drive.files.insert,
                             :body_object => file,
                             :media => media,
                             :parameters => {
                               'uploadType' => 'multipart',
                               'alt' => 'json'})
  end

  def set_start_folder(by_id:nil, by_query:nil, by_title_query:nil)
    log("Starting to set start folder.")
    if by_id
      folder_id=by_id
    else
      folder_id='root'
    end

    list_options = {'folderId' => folder_id}
    if by_title_query
      list_options.merge!({'q' => "title contains '#{by_title_query}'"})
      log("Query folder with #{list_options}")
    end

    @start_folder = @client.execute(api_method: @drive.children.list,
                                    parameters: list_options)
    log("Set start folder to #{@start_folder}\n")
    log("Found #{@start_folder.data.items.count} items")
  end

  def run_backups(formats)
    filename = 'tmp'
    @start_folder.data.items.each do |item|
      log("Getting #{item.id}")
      metadata = @client.execute(api_method: @drive.files.get,
                                 parameters: {
                                   "fileId" => item.id
                                 })
      written = false
      item_data = metadata.data 

      # Ignore Google Forms, compressed files and images
      if item_data['mimeType'] == 'application/vnd.google-apps.form' || /image/.match(item_data['mimeType']) || /zip/.match(item_data['mimeType'])
        next
      end
      
      if /folder/.match item_data['mimeType']
        child_backup = GoogleBackup.new(@config, destination_folder: "#{@destination_folder}/" + item_data['title'], client: @client )
        child_backup.set_start_folder(by_id: item_data['id'])
        child_backup.run_backups(formats)
      elsif item_data['title'].nil? # There are sometimes backend errors that cause this to happen
        log("Fatal error: this item returned unrecoverable errors (#{item_data.to_hash}).")
      else
        log(">>> Using item_data: #{item_data.to_hash}")
        filename = item_data['title']
        filename = filename.gsub(/ /, '_')
        filename = filename.gsub(/[\/\\]/, '_')
        log(">>> Using filename #{filename}")

        has_download = false
        if item_data['downloadUrl'] or item_data['exportLinks']
          if item_data['downloadUrl']
            link_pairs = {item_data['mimeType'] => item_data['downloadUrl']}
          else
            link_pairs = item_data['exportLinks'].to_hash 
          end
          has_download=true
        end
        if !has_download
          puts "No export links."
          puts item_data.to_hash
          exit -1
        end
          
        # Return an array of links that correspond to matched formats ... assuming format strings are unique in the 
        # list of download links
        download_links = []
        formats.each do |fmt|
          matched_pair = link_pairs.select do |k, v|
            log("Looking at #{fmt} with #{k}")
            fmt.match k
          end 
          download_links << [matched_pair.keys[0], matched_pair[matched_pair.keys[0]]] unless matched_pair.empty?
        end

        # Exits if no format was known
        if download_links.empty?
          raise GoogleBackup::NoKnownFormat, "Couldn't find a known format in the list #{link_pairs.keys}}"
        end

        # TODO: Let's just take the first downloadable format - but do it better in the future.
        target_file = filename + ".#{convert_to_extension(download_links.first[0])}"

        if !File.exists?(full_path(target_file)) or (backup_is_older?(item_data, target_file))
          log(">>> Backup is older... copying")
          make_local_copy(download_links.first[1], target_file)
        end
      end
    end
  end

  private

  def log (mesg)
    if @config['debug']
      $stderr.write("#{mesg}\n")
    end
  end

  def convert_to_extension(mime_type)
    if @known_conversions[mime_type]
      return @known_conversions[mime_type]
    end
      
    raise GoogleBackup::UnknownMimeType, "#{mime_type} unknown"
  end

  def full_path(filename)
    # Use the current destination folder in the recursion to qualify a file
    File.join(@destination_folder, filename)
  end

  def backup_is_older?(item_data, filename)
    # This assumes filename exists
    upload_mtime = item_data['modifiedDate']
    download_mtime = File.mtime full_path(filename)

    # TODO: What to do if the uploaded file is somehow modified EARLIER than the downloaded cache? (ie backup was modified?)
    log(">>> Comparing backup mtime #{download_mtime} to #{upload_mtime}")

    return true if download_mtime.to_f < upload_mtime.to_f
    return false
  end

  def request_authorization
    uri = @client.authorization.authorization_uri
    Launchy.open(uri)

    # Exchange authorization code for access token
    $stdout.write "Enter authorization code: "
    @client.authorization.code = gets.chomp
  end

  def exchange_code(authorization_code)
    @client.authorization.redirect_uri = @config.redirect_uri

    begin
      @client.authorization.fetch_access_token!
      return client.authorization
    rescue Signet::AuthorizationError
      raise CodeExchangeError.new(nil)
    end
  end

  def make_local_copy(link, target_file)
    log(">>> Using download link value <#{link}>, writing to #{@destination_folder}/#{target_file}")
    
    open(link, "Authorization" => "Bearer #{@client.authorization.access_token}") do |f|
      
      wrt = File.open(full_path(target_file), 'w')
      while ( (buffer = f.read()) && buffer != '') do
        wrt.write buffer
      end
    end
  end
end

begin
  config=ParseConfig.new('gd_config.ini')
rescue Errno::EACCES => e
  $stderr.write("There needs to be a config file called gd_config.ini (#{e.class}, #{e.message})\n")
  exit -1
end

backup = GoogleBackup.new(config)
backup.do_authorization
$stderr.write("Finished authorization\n")

# -- main code starts here --
# result = insert_file(client, drive, 'document.txt')

title=nil
if ARGV.size > 0
  title = ARGV[0]
end

backup.set_start_folder(by_title_query: title)

#application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
formats=[/office.*sheet/, /officedocument.wordprocessingml/, 'ppt', /text.plain/, /pdf/, /text.*tab.*values/, /msword/, /opendocument.text/]
backup.run_backups(formats)

