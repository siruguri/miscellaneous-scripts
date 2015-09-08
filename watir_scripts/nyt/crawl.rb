# coding: utf-8

require 'yaml'
require 'watir-webdriver'
require 'headless'
require 'nokogiri'
require 'pry'
require 'net/http'

require_relative '../../database_connector.rb'


class NytCrawler
  def initialize(db_c, cfg=nil)

    @_conn = db_c
    @try_text = ''
    @fetched_counter = 0
    @headless = Headless.new
    @headless.start
    @config = cfg
  end
  
  def run_crawler
    # Hard codes structure of NYT's feed's atom (which should be about the same as any other RSS format)
    start = true
    b = nil
    xml_descriptions = get_xml_dom

    xml_descriptions.children[1].children[0].children.select do |item|
      item.name == 'item'
    end.each do |story_item|
      story_item.children.select do |i|
        i.name == 'title'
      end.each do |story_title|
        err story_title.text
        get_browser
        query = (story_title.text.downcase.split(/\s+/).uniq - stop_words)[0..3].join('+')
        
        produce_file query
        sleep 5
      end
    end

    if @browser
      @browser.close
    end
  end
  
  private
  def get_browser
    if @config['environment'] == 'test'
      @browser = nil
    else
      @browser ||= Watir::Browser.new #:phantomjs
    end
  end
      
  def err(m)
    $stderr.write m+"\n"
  end
  
  def stop_words
    %w(a able it's about above abst accordance according accordingly across act actually added adj affected affecting affects after afterwards again against ah all almost alone along already also although always am among amongst an and announce another any anybody anyhow anymore anyone anything anyway anyways anywhere apparently approximately are aren arent arise around as aside ask asking at auth available away awfully b back be became because become becomes becoming been before beforehand begin beginning beginnings begins behind being believe below beside besides between beyond biol both brief briefly but by c ca came can cannot can't cause causes certain certainly co com come comes contain containing contains could couldnt d date did didn't different do does doesn't doing done don't down downwards due during e each ed edu effect eg eight eighty either else elsewhere end ending enough especially et et-al etc even ever every everybody everyone everything everywhere ex except f far few ff fifth first five fix followed following follows for former formerly forth found four from further furthermore g gave get gets getting give given gives giving go goes gone got gotten h had happens hardly has hasn't have haven't having he hed hence her here hereafter hereby herein heres hereupon hers herself hes hi hid him himself his hither home how howbeit however hundred i id ie if i'll im immediate immediately importance important in inc indeed index information instead into invention inward is isn't it itd it'll its itself i've j just k keep keeps kept kg km know known knows l largely last lately later latter latterly least less lest let lets like liked likely line little ll look looking looks ltd m made mainly make makes many may maybe me mean means meantime meanwhile merely mg might million miss ml more moreover most mostly mr mrs much mug must my myself n na name namely nay nd near nearly necessarily necessary need needs neither never nevertheless new next nine ninety no nobody non none nonetheless noone nor normally nos not noted nothing now nowhere o obtain obtained obviously of off often oh ok okay old omitted on once one ones only onto or ord other others otherwise ought our ours ourselves out outside over overall owing own p page pages part particular particularly past per perhaps placed please plus poorly possible possibly potentially pp predominantly present previously primarily probably promptly proud provides put q que quickly quite qv r ran rather rd re readily really recent recently ref refs regarding regardless regards related relatively research respectively resulted resulting results right run s said same saw say saying says sec section see seeing seem seemed seeming seems seen self selves sent seven several shall she shed she'll shes should shouldn't show showed shown showns shows significant significantly similar similarly since six slightly so some somebody somehow someone somethan something sometime sometimes somewhat somewhere soon sorry specifically specified specify specifying still stop strongly sub substantially successfully such sufficiently suggest sup sure than that that's the their theirs them themselves then there there's these they they'd they'll they're they've this those through to too under until up very was wasn't we we'd we'll we're we've were weren't what what's when when's where where's which while who who's whom why why's with won't would wouldn't x you you'd you'll you're you've your yours yourself yourselves)
  end

  def get_xml_dom
    str = nil
    
    if filename = get_config(:rss_xml_file, nil)
      if File.exists?(filename)
        str = File.open(filename).readlines.join ' '
      end
    end

    unless str
      url = get_config(:rss_xml, 'http://rss.nytimes.com/services/xml/rss/nyt/AsiaPacific.xml')
      err "Getting XML feed for #{url}"
      str = Net::HTTP.get URI(url)
    end

    Nokogiri::XML.parse str
  end

  def get_config(key, default)
    if @config and (@config[key.to_s] or @config[key])
      @config[key] || @config[key.to_s]
    else
      default
    end
  end
  
  def extract_nyt_link(url)
    if @browser
      begin
        @browser.goto url

        err 'Looking for News Answer'
        phantom_links = @browser.div(css: '._yE').as.select { |l| /http...www.nytimes.com/.match(l.attribute_value('href')) }
        if phantom_links.size > 0 
          return phantom_links[0]
        else
          raise Watir::Exception::UnknownObjectException
        end
      rescue Watir::Exception::UnknownObjectException => e
        err 'Not found. Looking in organic results'
        link = @browser.divs(:css => ".srg .g")[0].as[0]
      rescue Errno::ECONNREFUSED => e
        err 'Connection refused... did the screen close?'
        nil
      end
    else # in test env
      nil
    end
  end

  def get_nyt_content(link)
    if link
      link.click
      sleep 5

      all_ps = @browser.ps

      ctr = 0
      all_ps.each_with_index do |elt, idx|
        begin
          @try_text += elt.text
          @try_text += "\n<p>"
          ctr = idx
        rescue Watir::Exception::UnknownObjectException => f
          err "No text element in paragraph"
        rescue Selenium::WebDriver::Error::StaleElementReferenceError => f
          err "Driver ran out of steam."
        end
      end

      err "Tried to print #{ctr} lines from article"
    else # in test env
      @try_text = 'all some awesome content in some awesome article'
    end
    
    @try_text
  end

  def href_to_filename(link)
    #"http://sinosphere.blogs.nytimes.com/2015/07/06/q-a-xie-shi-on-the-brotherhood-of-skateboarding-in-chinas-far-west/"

    if !link
      return 'nil test filename'
    end
    
    href = link.attribute_value 'href'
    href.chomp!('/')
    
    match =  /\/(([^\?\/]+)[^\/]*$)/.match href 
    filename = match[2]
    filename.gsub!(/[^a-zA-Z0-9]/, '_')

    if /_html$/.match filename
      filename.gsub!(/_html$/, '.html')
    else
      filename += '.html'
    end

    filename
  end  


  def db_execute(q)
    @_conn.execute q
  end
  
  def add_to_db(title, body, date)
    title = db_safe title
    body = db_safe body
    db_execute("insert into articles (title, body, crawled_date) values ('#{title}', '#{body}', '#{date}')")
  end
    
  def produce_file(q)
    # Get link from Google
    # Download link if it's not in DB
    err "Getting NYT link from Google search page via query nyt+#{q}"
    link = extract_nyt_link "https://www.google.com/search?q=nyt+#{q}"

    outfile = db_safe(href_to_filename(link))
    err "Writing to #{outfile}"

    t = Date.today
    unless db_execute("select count(*) from articles where title='#{outfile}' and crawled_date='#{t}'")[0][0] > 0
      begin
        content = get_nyt_content link
      # My Internet connection sucks!
      rescue Net::ReadTimeout => e
        err "Timed out. Moving on."
      else

        add_to_db(outfile, content, t)
      ensure
        @fetched_counter += 1
        if @fetched_counter == 10
          @fetched_counter = 0
          if @browser
            @browser.close
            @browser=nil
          end
          
          get_browser
        end
      end        
    else
      err "Skipping. File exists"
    end
  end

  def db_safe(str)
    str if !(str.is_a? String)
    # Learned about this from http://stackoverflow.com/questions/1542214/weird-backslash-substitution-in-ruby
    # str.gsub /'/, '\\\\\''
    str.gsub /'/, " replaced_quoted_string_blech "
  end
end

if File.exists? 'config.yml'
  config = YAML.load_file 'config.yml'
end

db_c = DatabaseConnector.new(config['db_file'] || 'db.sqlite')
db_c.create_table 'articles', 'id integer primary key, title text, body text, crawled_date datetime'
db_c.create_table 'categories', 'id integer primary key, article_id integer, name string'

NytCrawler.new(db_c, config).run_crawler
