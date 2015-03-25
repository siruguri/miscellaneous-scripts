require "watir-webdriver"

require 'pry-byebug'

class LiveLogin
  def initialize
    @driver = Watir::Browser.new :phantomjs
    @words = File.open('/usr/share/dict/words').readlines
    @login_data = YAML.load_file 'passwords.txt'
  end

  def run_all
    @login_data['login_info'].each do |login_info_hash|
      @uid = uid = login_info_hash['uid']
      @pwd = pwd = login_info_hash['pwd']
      live_login
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
      live_login

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


    puts "Logging out #{@uid}"
    @driver.span(id: 'id_n').when_present.click
#    Watir::Wait.until { @driver.element?(class: 'id_link_text') }

    @driver.span(class: 'id_link_text').when_present.click
  end
  
  def live_login
    @driver.goto "http://login.live.com/"
    @driver.wait

    puts "Logging in #{@uid}"
    elt_uid = @driver.text_field(name: 'login')
    elt_uid.set(@uid)

    elt_pwd = @driver.text_field(name: 'passwd')
    elt_pwd.set(@pwd)

    @driver.button(id: 'idSIButton9').click
    @driver.wait
    puts "Contains login id - #{Regexp.new(@uid).match(@driver.body.text)}"
  end
  
  def run_searches
    @driver.goto 'http://www.bing.com/?q=start'
    @driver.wait
    puts "Reached start page: #{@driver.title}"

    point_counts = {}
    (1..32).each do |turn|
      # This sleep might be necessary to get the Javascript to finish getting points.
      sleep 2
      elt = @driver.text_field(name: 'q')
      elt.set ''

      random_word = @words[Random.rand(100000)].chomp

      pts = @driver.span(id: 'id_rc').text.to_i
      point_counts[pts] ||= 0
      point_counts[pts] += 1

      # Stop this if points don't go up after two tries.
      break if point_counts[pts] > 2
      
      puts "Searching for #{random_word} with #{pts} points"
      elt.set random_word
      @driver.button(id: 'sb_form_go').click
      @driver.wait
    end
  end
end

LiveLogin.new.run_all

