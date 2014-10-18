module Parsers
  class YahooDirMainPage
    def initialize(url_rec)
      @url_rec=url_rec
    end

    def produce(dom)
      # Need to check for error condition
      json = {status: 'success'}
      cats_a = dom.css '.lft_cat h1 a'
      cats_a |= dom.css('.rgt_cat h1 a')

      crawl_targets = cats_a.map do |elt|
        elt.attr('href')
      end
      payload={hierarchy: {root: {name: 'Yahoo! Dir'}}}
      payload[:hierarchy][:children] = (cats_a.map do |elt|
                                          {soft: false, name: elt.text}
                                        end)

      json.merge({crawl_list: crawl_targets, payload: payload})
    end
  end
end
