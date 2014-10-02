class UrlProcessor
  def initialize(url_rec)
    @url_rec=url_rec
  end

  def process
    ParserConfig.all.each do |parser_rec|
      # Find each matching regular expression for the URL and use its processor
      re=Regexp.new parser_rec.pattern
      if re.match @url_rec.url
        json=("Parsers::#{parser_rec.class_name}").constantize.new(@url_rec).produce

        unless json[:status]=='error'
          store_json json
          @url_rec.number_of_crawls+=1
          @url_rec.last_crawled=Time.now
          @url_rec.save
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

        TargetUrl.create(url: new_url, first_added: Time.now, number_of_crawls: 0, my_queue_id: @url_rec.my_queue_id)
      end
    end

    u=UrlPayload.new(payload: json[:payload])
    u.target_url=@url_rec
    u.save
  end
end


