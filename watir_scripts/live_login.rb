require "watir-webdriver"

require 'pry-byebug'

class LiveLogin
  def initialize
    @driver = Watir::Browser.new :chrome
    @driver.window.resize_to(1024, 928)
    
    @words = File.open('/usr/share/dict/words').readlines
    @login_data = YAML.load_file(File.join(File.dirname(__FILE__), 'passwords.txt'))
  end

  def run_all
    @login_data['login_info'].each do |login_info_hash|
      uid = login_info_hash['uid']
      pwd = login_info_hash['pwd']
      live_login(uid, pwd)
      sleep 5
      run_searches
      live_logout
    end
    @driver.close
  end

  def run_points_check
    @login_data['login_info'].each do |login_info_hash|
      uid = login_info_hash['uid']
      pwd = login_info_hash['pwd']
      live_login uid, pwd

      @driver.goto 'http://www.bing.com/?q=start'

      live_logout
      sleep 2 
    end
  end
  
  private
  def live_logout
    sleep 2
    @driver.goto('http://www.bing.com/')
    @driver.wait
    
    # This sleep is necessary to get the Javascript to finish getting the logout links.
    sleep 2

    @driver.span(id: 'id_n').click
    @driver.wait

    @driver.span(class: 'id_link_text').click
  end
  
  def live_login(uid, pwd)
    begin
      @driver.goto "http://login.live.com/"
    rescue Exception => e
    end

    @driver.wait
    puts "Logging in #{uid}"
    elt_uid = @driver.text_field(name: 'login')
    elt_uid.set(uid)

    elt_pwd = @driver.text_field(name: 'passwd')
    elt_pwd.set(pwd)

    @driver.button(id: 'idSIButton9').click
    @driver.wait
    puts "Contains login id - #{Regexp.new(uid).match(@driver.body.text)}"
  end
  
  def run_searches
    @driver.goto 'http://www.bing.com/?q=start'
    @driver.wait
    puts "Reached start page: #{@driver.title}"
    
    (1..32).each do |turn|
      # This sleep might be necessary to get the Javascript to finish getting points.
      sleep 2
      puts "Driver sees: #{@driver.span(id: 'id_rc').outer_html} points"
      elt = @driver.text_field(name: 'q')
      elt.set ''

      random_word = @words[Random.rand(90000)].chomp
      
      elt.set random_word

      # Wait for autocomplete to fetch content and then get the button
      sleep 1
      btn = @driver.button(id: 'sb_form_go')

      puts "Searching for #{random_word}"
      btn.click
      @driver.wait
    end
  end
end

LiveLogin.new.run_all

