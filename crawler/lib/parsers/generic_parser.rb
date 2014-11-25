module Parsers
  class GenericParser
    protected
    def add_crawl_link(a_node)
      if a_node.name.downcase.strip != 'a'
        return nil
      end

      href=a_node.attr 'href'
      uri=URI.parse @url_rec.url 

      # Relative link from top of domain
      if /^http/.match('href') or /^\/\//.match(href)
        if /^http/.match 'href'
          prefix=''
        else
          prefix="#{uri.scheme}:"
        end
      elsif /^\//.match href
        prefix=uri.scheme + "://" + uri.host
      else
        prefix=@url_rec.url
      end

      # If there are query parameters, remove them.
      prefix = prefix.gsub(/\?[^\/]*$/, '')
      crawl_url = prefix + href
      puts ">> found new target at #{crawl_url}"      

      @crawl_links << crawl_url
    end
  end
end
