require "selenium-webdriver"

class SeleniumBot
  def initialize
    @words = File.open('/usr/share/dict/words').readlines
    @driver = Selenium::WebDriver.for :firefox
    @driver.navigate.to "http://signup.live.com/"    

    # Set on Feb 20
    @uid_count = 4
  end
  
  def rand_word
    @words[Random.rand(100000)].chomp
  end

  def sign_up
    uid = 'liveaccount_' + sprintf("%02d", @uid_count) + '@yahoo.com'
    pwd=rand_word.capitalize + '8441'
    puts ">>> store these: #{uid}, #{pwd}"

    inputs = [rand_word, rand_word, uid, pwd, pwd, 77005, '5102334511']
    ['iFirstName', 'iLastName', 'imembernameeasi', 'iPwd', 'iRetypePwd', 'iZipCode', 'iPhone'].each_with_index do |elt_name, idx|
      elt = @driver.find_element(:name, elt_name)
      elt.send_keys inputs[idx]
    end

    # Drop downs
    [['iBirthMonth', 'January'], ['iBirthDay', '8'], ['iBirthYear', '1957'], ['iGender', 'Male']].each do |pair|
      
      dd_parent = @driver.find_element :name, pair[0]
      option = Selenium::WebDriver::Support::Select.new(dd_parent)
      option.select_by(:text, pair[1])
    end
  end

  def close
    @driver.quit
  end
end

sbot=SeleniumBot.new
sbot.sign_up
#sbot.close



