class UrlProcessor
  @@backoff_time = 1

  attr_accessor :url_rec
  def initialize(url_rec=nil)
    @url_rec=url_rec
  end

  def process
    ParserConfig.all.each do |parser_rec|
      # Find each matching regular expression for the URL and use its processor
      re=Regexp.new parser_rec.pattern
      url=@url_rec.url
      if re.match url
        attempted_class="Parsers::#{parser_rec.class_name}"
        recd_200=false
        begin
          html_resp = get_url_stream(url)
	  puts ">>> Received Net HTTP response"
          dom=Nokogiri::HTML  html_resp
        rescue OpenURI::HTTPError => e
          puts ">>> Error in fetching - ignoring because of #{e.message}"
          if /404/.match e.message
            update_url_rec_in_db
          end
        else
          recd_200=true
        end

        if recd_200
          puts ">>> Parsing #{url} added at #{@url_rec.first_added}"
          json=(attempted_class).constantize.new(@url_rec).produce(dom)

          unless json[:status]=='error'
            store_json json
            update_url_rec_in_db
          end
        end
      end
    end
  end

  private
  def get_url_stream(url)
    try_again=true

    while try_again
      begin
        puts ">>> Starting NetHTTP fetch"
        stream = open(url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE})
      rescue Errno::ECONNRESET, Errno::ECONNREFUSED, Errno::EADDRNOTAVAIL, Errno::ETIMEDOUT, Errno::EHOSTUNREACH, Errno::ENETDOWN, SocketError => e
        $stderr.write("Backing off for #{@@backoff_time} seconds\n")
        sleep @@backoff_time
        @@backoff_time *= 2
      else
        try_again=false
        @@backoff_time = 1
      end
    end

    stream
  end

  def store_json(json)
    url = @url_rec.url
    json[:crawl_list].each do |href|
      unless /^http/.match href
        new_url="#{url}".gsub(/\/?$/, '') + href
      else
        new_url=href
      end

      unless TargetUrl.find_by_url(new_url)
        puts ">> adding new target #{new_url} for queue id #{@url_rec.my_queue_id}"
        t=TargetUrl.new(url: new_url, first_added: Time.now, number_of_crawls: 0, my_queue_id: @url_rec.my_queue_id)
        t.save
      end
    end

    u=UrlPayload.find_or_initialize_by(target_url: @url_rec)
    u.payload = json[:payload]
    u.save
  end

  def update_url_rec_in_db
    @url_rec.number_of_crawls+=1
    @url_rec.last_crawled=Time.now
    @url_rec.save
  end
end


