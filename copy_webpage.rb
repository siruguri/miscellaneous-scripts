# This script will take a URL and create a local webpage that works,
# by substituting the URLs the right way

require 'httpclient'
require 'getoptlong'
require 'nokogiri'
require 'open-uri'
require 'css_parser'
include CssParser

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--url', '-u', GetoptLong::REQUIRED_ARGUMENT]
)

def error_exit(msg)
  puts "Error found... exiting ..."
  puts msg
  exit -1
end

def print_help_and_exit
  puts <<EOS
  #{__FILE__} [options]

  Options:
    -u, --url: URL to download

EOS
  exit 0
end

url = ''

opts.each do |opt, arg|
   case opt
     when '--help'
     print_help_and_exit

     when '--url'
     url = arg.to_s
   end
end

if url == ''
  print_help_and_exit
end

class WebpageCopier

  def initialize url
    @url = url
    client = HTTPClient.new
    content = client.get_content(@url)

    matches = /(http.?:\/\/[^\\]+)\//.match @url
    @base = matches[1]
    @dom_root = Nokogiri::HTML(content)
  end

  def change_style_files
    # Find src: attributes in the CSS file and "correct" them
    puts "Reading CSS files for URLs"
    parser = CssParser::Parser.new
    # load a local file, setting the base_dir and media_types
    files = Dir.glob "styles/*" 

    files.each do |file|
      write_parser=CssParser::Parser.new
      puts "Reading CSS #{file}"
      parser.load_file!(file)
      parser.each_selector do |sel, decl, specificity|
        # puts "#{sel},  {#{decl}},  #{specificity}"

        # This will fetch the URLs as well.
        new_decl = change_all_urls decl if /url\s*\(/.match decl
        str =  "#{sel} { #{new_decl} }"
        write_parser.add_block! str
      end

      f=File.open('tmp.css', 'w')
      f.write write_parser.to_s
      f.close

      File.rename('tmp.css', file)
    end
  end

  def fix_styles
    style_nodes = @dom_root.css 'link'

    style_nodes.each do |node|
      if node['rel']=='stylesheet' then
        src = locate_src node['href']
        name = name_from_url src
        write_to_file src, 'styles'

        node['href'] = "styles/#{name}"
      end
    end
  end

  def fix_imgs
    img_nodes = @dom_root.css 'img'

    img_nodes.each do |node|
      src = locate_src node['src']
      name = write_to_file src, 'images'

      node['src'] = "images/#{name}"
    end
  end

  def print filename
    File.open(filename, 'w') do |handle|
      handle.write(@dom_root.to_html)
    end
  end

  private

  def change_all_urls decl
    url_matches = decl.scan /url\s*\((.*?)([^\/)]+)\)/

    url_matches.each do |basename, last|
      write_to_file "#{@base}#{basename}#{last}", "assets"
    end

    new_decl = decl.gsub  /url\s*\((.*?)\/([^\/)]+)\)/, 'url(assets/\2)'
    #puts "Changed #{decl} to #{new_decl}"

    return new_decl
  end

  def write_to_file(src, write_dir, options={})
    # Will only write if file doesn't exist already (unless option['force_write'] is set)
    if !Dir.exists? write_dir
      Dir.mkdir write_dir
    end

    name = name_from_url src
    if File.exists?(File.join(write_dir, name)) && (options['force_write'].nil? || options['force_write']!=true)
      puts "File exists. Ignoring"
      return
    end

    puts "Downloading #{src} and writing to file #{name}"

    File.open("#{write_dir}/#{name}", 'wb') do |write_f|
      read_handle = open(src, 'rb')
      while (buff = read_handle.read(1024))
        write_f.write(buff)
      end
    end

    return name
  end

  def locate_src src_input
    src_str = src_input
    if src_str && src_str != '' then

      if !(/^https?:\/\//.match(src_str)) then
        # Make the image URL absolute if it is relative
        src_str = @url + (/\/$/.match(@url)? "":"/") + src_str
      end
    end

    puts "Source located from #{src_str}"

    return src_str
  end

  def name_from_url(url)
    matches = /([^\/]+)$/.match url

    return nil if matches.nil?

    return matches[1]
  end
end

copier = WebpageCopier.new url
copier.fix_imgs
copier.fix_styles

copier.change_style_files

copier.print "index.html"
