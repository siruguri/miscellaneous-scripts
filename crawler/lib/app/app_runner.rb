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
    
    # Infinite loop until everything's been crawled at least once.
    while !target_urls.empty?
      target_urls.each do |url_rec|
        UrlProcessor.new(url_rec).process
        sleep self.config(:sleep_interval)
      end

      target_urls = MyQueue.find_by_key(self.config(:queue_name)).target_urls.where(number_of_crawls: [0, nil])
      puts ">>> Next round: #{target_urls.size} URLs"
    end
  end
end
