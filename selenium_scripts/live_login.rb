require 'YAML'
require "selenium-webdriver"
require 'pry-byebug'

class LiveLogin
  def initialize
    @driver = Selenium::WebDriver.for :firefox
    @words = File.open('/usr/share/dict/words').readlines
    @login_data = YAML.load_file 'passwords.txt'
  end

  def run_all
    @login_data['login_info'].each do |login_info_hash|
      uid = login_info_hash['uid']
      pwd = login_info_hash['pwd']
      live_login(uid, pwd)
      run_searches
      live_logout
    end
    @driver.quit
  end

  def run_points_check
    @login_data['login_info'].each do |login_info_hash|
      uid = login_info_hash['uid']
      pwd = login_info_hash['pwd']
      live_login uid, pwd
      sleep 10
      
      @driver.navigate.to 'http://www.bing.com/?q=start'

      sleep 10
      live_logout
      sleep 2 
    end
  end
  
  private
  def live_logout
    sleep 2
    @driver.navigate.to('http://www.bing.com/')
    @driver.find_element(:id, 'id_n').click
    sleep 2
    @driver.find_element(:class, 'id_link_text').click
    
  end
  
  def live_login(uid, pwd)
    sleep 2
    @driver.navigate.to "http://login.live.com/"
    sleep 2
    elt_uid = @driver.find_element(:name, 'login')
    elt_uid.send_keys(uid)

    elt_pwd = @driver.find_element(:name, 'passwd')
    elt_pwd.send_keys(pwd)

    elt_pwd.submit
  end
  
  def run_searches
    sleep 8
    @driver.navigate.to 'http://www.bing.com/?q=start'

    (1..30).each do |turn|
      sleep 5
      elt = @driver.find_element :name, 'q'
      elt.clear

      random_word = @words[Random.rand(100000)].chomp
      
      elt.send_keys random_word
      elt.submit
    end
  end
end

LiveLogin.new.run_all

