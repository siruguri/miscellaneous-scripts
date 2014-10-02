module Parsers
  class YahooDirLevel1
    def initialize(url_rec)
      @url_rec=url_rec
    end

    def produce
      url=@url_rec.url

      puts ">> Running YahooDirLevel1 process for #{url}"
      dom=Nokogiri::HTML(open(url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}))

      # Need to check for error condition
      json = {status: 'success'}

      links = dom.css 'table li a'

      external_links = links.select do |link_node|
        /^http:/.match link_node.attr 'href'
      end.map do |link_node|
        puts ">> found external site at #{link_node.attr('href')}"

        {external_site: {title: link_node.text, url: link_node.attr('href')}}
      end

      crawl_links = (links.select do |link_node|
        !/^http:/.match link_node.attr 'href'
      end).map do |link_node|
        # Relative link from top of domain
        if /^\//.match link_node.attr('href')
          uri=URI.parse @url_rec.url 
          crawl_url=uri.scheme + "://" + uri.host + link_node.attr('href')
        else
          crawl_url=@url_rec.url.gsub(/\/?$/, '') + link_node.attr('href')
        end
        puts ">> found new target at #{crawl_url}"      

        crawl_url
      end

      json.merge({crawl_list: crawl_links, payload: external_links})
    end
  end
end
