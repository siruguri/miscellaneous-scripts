class UrlProcessor
  def initialize(url_rec)
    @url_rec=url_rec
  end

  def process
    ParserConfig.all.each do |parser_rec|
      # Find each matching regular expression for the URL and use its processor
      re=Regexp.new parser_rec.pattern
      url=@url_rec.url
      if re.match url
        attempted_class="Parsers::#{parser_rec.class_name}"
        puts ">>> Running #{attempted_class} process for #{url}"
        begin
          dom=Nokogiri::HTML(open(url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}))
        rescue OpenURI::HTTPError => e
          puts ">>> Error in fetching - ignoring because of #{e.message}"
        else
          json=(attempted_class).constantize.new(@url_rec).produce(dom)

          unless json[:status]=='error'
            store_json json
            @url_rec.number_of_crawls+=1
            @url_rec.last_crawled=Time.now
            @url_rec.save
          end
        end
      end
    end
  end

  private
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

        TargetUrl.find_or_create_by(url: new_url) do |t|
          t.first_added=Time.now
          t.number_of_crawls=0
          t.my_queue_id=@url_rec.my_queue_id
        end
      end
    end

    u=UrlPayload.find_or_initialize_by(target_url: @url_rec)
    u.payload = json[:payload]
    u.save
  end
end


