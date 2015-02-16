require "selenium-webdriver"

class SeleniumBot
  def initialize
    @words = File.open('/usr/share/dict/words').readlines
    @driver = Selenium::WebDriver.for :firefox
    @driver.navigate.to "http://signup.live.com/"
    @data = YAML.load_file 'passwords.txt'
  end
  
  def rand_word
    @words[Random.rand(100000)].chomp
  end

  def sign_up
    uid=@data['login_info'][0]['uid']
    pwd=@data['login_info'][0]['pwd']
    inputs = [rand_word, rand_word, 'liveaccount_03@yahoo.com', 'Barter332', 'Barter332', 77005, '5102334511']
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



