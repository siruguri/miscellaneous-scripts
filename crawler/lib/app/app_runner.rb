class AppRunner

  def initialize(cfg)
    @_cfg={}
    cfg.keys.each do |k|
      @_cfg[k]=cfg[k]
    end
  end

  def config(k)
    if @_cfg[k]
      ret=@_cfg[k]
    else
      ret=@_cfg["#{k}"]
    end

    ret
  end

  def run
    target_urls = MyQueue.find_by_key(self.config(:queue_name)).target_urls.where(number_of_crawls: [0, nil])
    url_processor = UrlProcessor.new
    
    # Infinite loop until everything's been crawled at least once.
    while !target_urls.empty?
      total = target_urls.size
      target_urls.each_with_index do |url_rec, idx|
        # special case for Yahoo Dir - don't crawl URLs pointing to page 0. Should put this in a 
        # blacklist feature later.
        next if /b=0$/.match url_rec.url

        puts ">>> Processing #{idx} / #{total}"
        url_processor.url_rec=url_rec
        url_processor.process
        sleep self.config(:sleep_interval)
      end

      target_urls = MyQueue.find_by_key(self.config(:queue_name)).target_urls.where(number_of_crawls: [0, nil]).order(:first_added)
      puts ">>> Next round: #{target_urls.size} URLs"
    end
  end
end
