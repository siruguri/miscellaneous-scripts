require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

Dotenv.load

class OneNyt
  def initialize(opts={})
    @config = YAML.load_file opts[:config]
    @browser = Watir::Browser.new(@config['browser'] || :phantomjs)
  end
    
  def extract_nyt_link(url)
    begin
      @browser.goto url
      
      err 'Looking for News Answer'
      
      phantom_links = all_google_page_links.select do |l|
        err "Looking at href = #{l.attribute_value('href')}"
        nytimes_regex.match(l.attribute_value('data-href')) or
          nytimes_regex.match(l.attribute_value('href'))
      end
      
      if phantom_links.size > 0
        err "Picking #{phantom_links[0].attribute_value('href')}"
        return phantom_links[0]
      else
        raise Watir::Exception::UnknownObjectException
      end
    rescue Watir::Exception::UnknownObjectException => e
      err 'Not found. Looking in organic results'
      link = @browser.divs(:css => ".srg .g")[0].as[0]
    rescue Errno::ECONNREFUSED, Net::ReadTimeout => e
      # on my desktop maybe the screen shut down
      if get_config(:machine_location, 'anonymous') == 'osx' and e.class == Net::ReadTimeout
        err "Maybe your screen shut down? Press enter."
        $stdin.gets
      else
        mesg = 'Connection refused or Internet connection timed out ... did the screen close?'
        err mesg
      end
      nil
    end
  end

  def run(q)
    u="https://www.google.com/search?q=nyt+#{q}"
    err "Google search: #{u}"
    link = extract_nyt_link u
    content = get_nyt_content link
    puts content
  end

  def close
    @browser.close
  end
    
  def get_nyt_content(link)
    @try_text = ''
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
    
    @try_text
  end

  private
  def all_google_page_links
    if @config['browser'] == 'chrome'
      @browser.div(css: '._yE').as
    else
      @browser.as
    end
  end

  def err(m)
    t = Date.today
    $stderr.write t.inspect + ": " + m + "\n"
  end

  def nytimes_regex
    # /url?q=http://www.nytimes.com/2015/10/20/health/a-new-life-or-death-approach-t
    /(http.?:\/\/.*\w+\.nytimes\.com)|(url=http.3A.2F.2F.*.\w+\.nytimes\.com.2F)/
  end
  
end

if File.exists? 'config/app.yml'
  #binding.pry
  n = OneNyt.new(config: 'config/app.yml')
else
  puts "No config/app.yml - do something abt it"
end

n.run(ARGV[0] || 'chapo search again')
n.close
