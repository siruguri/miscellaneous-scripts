module Parsers
  class YahooDirLevel1 < GenericParser
    def initialize(url_rec)
      @url_rec=url_rec
      @hierarchy={children: []} 
      @crawl_links=[]
    end

    def produce(dom)
      # Need to check for error condition
      json = {status: 'success'}

      tables = dom.css 'table table table'

      ext_links=dir_links=[]
      tables.select { |t| !t.css('.headers').empty? }.each do |info_table|
        header = info_table.css('.headers').css('b').text
        if header.downcase == 'categories'
          dir_links = info_table.css 'li a'
        else
          ext_links |= info_table.css 'li a'
        end
      end

      payload={}
      payload[:directory_listings]=[]
      @hierarchy[:root]={name: dom.css('.col1 h1').text}

      ext_links.each do |link_node|
        if /^http/.match(link_node.attr('href')) and !(/dir.yahoo.com/.match link_node.attr('href'))
          # Modifies hierarchy and crawl links
          payload[:directory_listings] << {title: link_node.text, url: link_node.attr('href')}
        else
          add_crawl_link link_node
          add_child link_node
        end
      end

      dir_links.each do |link_node|
        # Modifies hierarchy and crawl links
        add_crawl_link link_node
        add_child link_node
      end
      payload[:hierarchy]=@hierarchy

      dom.css('#yschpg a').each do |a_node|
        add_crawl_link a_node
      end

      json.merge({crawl_list: @crawl_links, payload: payload})
    end

    private
    def add_child(child_node)
      child_name = child_node.css('b').text
      if /\@$/.match child_name
        is_soft=true
        child_name.gsub! /\@$/, ''
      else
        is_soft=false
      end
      @hierarchy[:children] << {soft: is_soft, name: child_name}
    end
  end
end
