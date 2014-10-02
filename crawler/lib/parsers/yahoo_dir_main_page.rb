module Parsers
  class YahooDirMainPage
    def initialize(url_rec)
      @url_rec=url_rec
    end

    def produce
      url=@url_rec.url

      puts ">> Running YahooDirMainPage process for #{url}"
      dom=Nokogiri::HTML(open(url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}))

      # Need to check for error condition
      json = {status: 'success'}
      cats_a = dom.css '.lft_cat a'
      cats_a |= dom.css('.rgt_cat a')

      crawl_targets = cats_a.map do |elt|
        elt.attr('href')
      end
      payload=cats_a.map do |elt|
        {cat_name: elt.text, href: elt.attr('href')}
      end

      json.merge({crawl_list: crawl_targets, payload: payload})
    end
  end
end
