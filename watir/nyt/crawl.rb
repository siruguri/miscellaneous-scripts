require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

Dotenv.load

require_relative '../../ruby/ar_database_connector.rb'

Dir.glob('models/*.rb').each do |f|
  require_relative f
end
Dir.glob('lib/*.rb').each do |f|
  require_relative f
end

module LocalRefinements
  refine Nokogiri::XML::Document do
    def nyt_story_items
      children[1].children[0].children.select do |item|
        item.name == 'item'
      end      
    end
  end
end

class NytCrawler
  using LocalRefinements
  attr_reader :loop_count

  def initialize(cfg=nil)
    @try_text = ''
    @fetched_counter = 0
    @headless = Headless.new
    @headless.start
    @config = cfg

    @mailer = MailerClass.new(username: ENV['gmail_username'], password: ENV['gmail_password'])
    @today_date = Date.today.to_datetime
  end

  def send_mail
    if @mailer
      @mailer.sendmail_smtp to: 'sameer@dstrategies.org',
                            subject: ('NYT Crawler report ' + Time.now.strftime("%Y-%m-%d: %H:%M"))
    end
  end
  
  def one_run
    # Get one page, its links and stops
    get_browser
    one_link = @config['one_link'] || 'http://www.nytimes.com/2015/09/20/opinion/is-big-tech-too-powerful-ask-google.html'
    
    t = get_nyt_content one_link
    puts "Text length is #{t.size}"

    get_nyt_page_links.each do |l|
      puts "Link is #{l.attribute_value('href')}"
    end
  end
  
  def run_crawler
    # Hard codes structure of NYT's feed's atom (which should be about the same as any other RSS format)
    start = true
    b = nil
    get_xml_doms.each do |source|
      @mailer.add_line "<hr/><p>Reading XML feed #{source}</p><p><b>Titles</b></p><ol>"
      xml_descriptions = get_xml_dom(source)
      xml_descriptions.nyt_story_items.each do |story_item|
        categories = []
        title = ''
        pub_date = @today_date
        story_item.children.each do |i|
          if i.name == 'title'
            title = i.text
          elsif i.name == 'category'
            categories << i.text
          elsif i.name == 'pubDate'
            pub_date = DateTime.strptime(i.text, '%a, %e %b %Y %T %Z')
          end
        end
        
        err "#{title} #{categories} (pub on #{pub_date})"
        @mailer.add_line "<li>#{title}: "
        @mailer.add_line(categories.to_s)
        @mailer.add_line "<i>#{pub_date})</i></li>"
                           
        get_browser
        produce_file title, categories, pub_date

        increment_loop
        if testing? and loop_count > 100
          break
        end
      end
      @mailer.add_line '</ol>'
      
      if testing? and loop_count > 100
        break
      end
    end
    # All XMLs processed now.

    if @browser
      @browser.close
    end
  end
  
  private
  def testing?
    @config['environment'] == 'test'
  end

  def increment_loop
    @loop_count ||= 0
    @loop_count += 1
  end

  def nytimes_regex
    /(http.?:\/\/.*\w+\.nytimes\.com)|(url=http.3A.2F.2F.*.\w+\.nytimes\.com.2F)/
  end
  
  def get_browser
    @browser ||= Watir::Browser.new :phantomjs
  end
      
  def err(m)
    $stderr.write m+"\n"
  end
  
  def stop_words
    %w(a able it's about above abst accordance according accordingly across act actually added adj affected affecting affects after afterwards again against ah all almost alone along already also although always am among amongst an and announce another any anybody anyhow anymore anyone anything anyway anyways anywhere apparently approximately are aren arent arise around as aside ask asking at auth available away awfully b back be became because become becomes becoming been before beforehand begin beginning beginnings begins behind being believe below beside besides between beyond biol both brief briefly but by c ca came can cannot can't cause causes certain certainly co com come comes contain containing contains could couldnt d date did didn't different do does doesn't doing done don't down downwards due during e each ed edu effect eg eight eighty either else elsewhere end ending enough especially et et-al etc even ever every everybody everyone everything everywhere ex except f far few ff fifth first five fix followed following follows for former formerly forth found four from further furthermore g gave get gets getting give given gives giving go goes gone got gotten h had happens hardly has hasn't have haven't having he hed hence her here hereafter hereby herein heres hereupon hers herself hes hi hid him himself his hither home how howbeit however hundred i id ie if i'll im immediate immediately importance important in inc indeed index information instead into invention inward is isn't it itd it'll its itself i've j just k keep keeps kept kg km know known knows l largely last lately later latter latterly least less lest let lets like liked likely line little ll look looking looks ltd m made mainly make makes many may maybe me mean means meantime meanwhile merely mg might million miss ml more moreover most mostly mr mrs much mug must my myself n na name namely nay nd near nearly necessarily necessary need needs neither never nevertheless new next nine ninety no nobody non none nonetheless noone nor normally nos not noted nothing now nowhere o obtain obtained obviously of off often oh ok okay old omitted on once one ones only onto or ord other others otherwise ought our ours ourselves out outside over overall owing own p page pages part particular particularly past per perhaps placed please plus poorly possible possibly potentially pp predominantly present previously primarily probably promptly proud provides put q que quickly quite qv r ran rather rd re readily really recent recently ref refs regarding regardless regards related relatively research respectively resulted resulting results right run s said same saw say saying says sec section see seeing seem seemed seeming seems seen self selves sent seven several shall she shed she'll shes should shouldn't show showed shown showns shows significant significantly similar similarly since six slightly so some somebody somehow someone somethan something sometime sometimes somewhat somewhere soon sorry specifically specified specify specifying still stop strongly sub substantially successfully such sufficiently suggest sup sure than that that's the their theirs them themselves then there there's these they they'd they'll they're they've this those through to too under until up very was wasn't we we'd we'll we're we've were weren't what what's when when's where where's which while who who's whom why why's with won't would wouldn't x you you'd you'll you're you've your yours yourself yourselves)
  end

  def get_xml_doms
    source_var = nil
    unless (source_var = get_config(:rss_xml_file, nil))
      source_var = get_config(:rss_xml, 'http://rss.nytimes.com/services/xml/rss/nyt/AsiaPacific.xml')
    end
    source_var= [source_var].flatten
  end
  
  def get_xml_dom(xml_source)
    str = nil
    
    if File.exists? xml_source
      str = File.open(xml_source).readlines.join ' '
    else
      err "Getting XML feed for #{xml_source}"
      str = Net::HTTP.get URI(xml_source)
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
        phantom_links = @browser.div(css: '._yE').as.select do |l|
          err "Looking at href = #{l.attribute_value('href')}"
          nytimes_regex.match(l.attribute_value('data-href')) or
            nytimes_regex.match(l.attribute_value('href'))
        end
        
        if phantom_links.size > 0 
          return phantom_links[0]
        else
          raise Watir::Exception::UnknownObjectException
        end
      rescue Watir::Exception::UnknownObjectException => e
        err 'Not found. Looking in organic results'
        link = @browser.divs(:css => ".srg .g")[0].as[0]
      rescue Errno::ECONNREFUSED, Net::ReadTimeout => e
        # on my desktop maybe the screen shut down
        if get_config(:machine_location) == 'osx' and e.class == Net::ReadTimeout
          err "Maybe your screen shut down? Press enter."
          $stdin.gets
        else
          mesg = 'Connection refused or Internet connection timed out ... did the screen close?'
          err mesg
          @mailer.add_line mesg
        end
        nil
      end
    else # in test env
      nil
    end
  end

  def get_nyt_page_links
    return [] if @browser.nil?
    @browser.as.select { |l| /20\d\d\/\d+\/\d+\//.match l.attribute_value('href')}
  end
  
  def get_nyt_content(link)
    @try_text = ''
    if link
      ctr = 0
      begin
        if link.is_a? String
          @browser.goto link
        else
          link.click
        end
        sleep 5

        all_ps = @browser.ps
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
      rescue Selenium::WebDriver::Error::UnknownError
        # Probably the link is just below-the-fold
        err "Probably the link is just below-the-fold"
      end

      err "Tried to print #{ctr} lines from article"
    else # in test env
      @try_text = 'all some awesome content in some awesome article'
    end
    
    @try_text
  end

  def href_to_filename(link)
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


  def add_to_db(title, body, date)
    Article.create title: title, body: body, pub_date: date 
  end

  def add_article_category!(article, c)
    article = article.class == Array ? article[0] : article
    
    c = Category.find_or_create_by category_name: c
    
    unless Categorization.where(article: article, category: c).count > 0
      Categorization.create article: article, category: c
    end
  end
  
  def add_article_categories!(article, categories)
    categories.each do |c|
      add_article_category! article, c
    end
  end
  
  # Return array of articles that match title and pub date's date 
  def retrieve_articles(title, date)
    Article.where(title: title).all.select do |a|
      a.pub_date.to_date == date.to_date
    end
  end
  
  def pre_process_title(t)
    tp = (t.downcase.split(/\s+/) - stop_words).join ' '
    tp = tp.gsub(/^(\w+ \w+: )/, '')
    tp = tp.split(/\s+/).uniq[0..3].join('+')
    tp = tp.gsub(/[\:\-\&\>\<\.\;\_]/, '+')
    tp
  end
    
  def produce_file(title, category_list, pub_date)
    # Get link from Google
    # Download link if it's not in DB
    err "Initial title: #{title}"

    old_article_list = retrieve_articles title, pub_date
    if old_article_list.empty?
      # Article should be inserted
      q = pre_process_title title
    
      u="https://www.google.com/search?q=nyt+#{q}"
      err "Google search: #{u}"
      link = extract_nyt_link u

      outfile = href_to_filename link
      err "Writing to #{outfile}"

      unless testing?
        begin
          content = get_nyt_content link
        # My Internet connection sucks!
        rescue Net::ReadTimeout => e
          err "Timed out. Moving on."
        else
          inserted_article = add_to_db(title, content, pub_date)
        ensure
          sleep 5
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
      end     # Skip all the article extraction in test
    else
      err "File exists - not re-crawling"
    end
    
    if old_article_list.empty?
      add_article_categories! inserted_article, category_list
    else
      old_article_list.each do |a|
      add_article_categories! a, category_list
      end
    end
  end
end

if File.exists? 'config/app.yml'
  config = YAML.load_file 'config/app.yml'
end

db_c = ArDatabaseConnector.new 'config/database.yml'
db_c.run_migrations 'migrations'

filename = 'db/schema.sql'
unless File.exists? filename
  File.open(filename, "w:utf-8") do |file|
    db_c.dump_schema file
  end
end
#binding.pry
n = NytCrawler.new(config)

if config['one_run']
  n.one_run
else
  n.run_crawler
end
n.send_mail
