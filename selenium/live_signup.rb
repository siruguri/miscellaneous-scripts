require "selenium-webdriver"

class SeleniumBot
  def initialize(counter)
    @words = File.open('/usr/share/dict/words').readlines
    @driver = Selenium::WebDriver.for :firefox
    @driver.navigate.to "http://signup.live.com/"    

    # Set on Mar 15
    @uid_count = counter
  end
  
  def rand_word
    @words[Random.rand(100000)].chomp
  end

  def sign_up
    uid = 'liveaccount_' + sprintf("%02d", @uid_count) + '@yahoo.com'
    pwd=rand_word.capitalize + '8441'
    puts ">>> store these:\n  -\n    uid: #{uid}\n    pwd: #{pwd}\n"
    
    first_name_id = ''
    inputs = []
    
    if @driver.find_elements(:name, 'LastName').size > 0
      id_list = ['FirstName', 'LastName', 'MemberName', 'Password', 'RetypePassword', 'PhoneNumber']
      inputs = [rand_word, rand_word, uid, pwd, pwd, '5102334511']
      first_name_id = 'FirstName'
    else
      id_list = ['iFirstName', 'iLastName', 'imembernameeasi', 'iPwd', 'iRetypePwd', 'iZipCode', 'iPhone']
      inputs = [rand_word, rand_word, uid, pwd, pwd, '77005', '5102334511']
      first_name_id = 'iFirstName'
    end

    id_list.each_with_index do |elt_name, idx|
      elt = @driver.find_element(:name, elt_name)

      puts "Filling in #{elt_name} with #{inputs[idx]}"


      if elt_name == 'Password' or elt_name == 'RetypePassword' or elt_name == 'PhoneNumber' \
        or elt_name == 'iPwd' or elt_name == 'iRetypePwd' or elt_name == 'iPhone'
        elt.send_keys ''
        sleep 1
      end

      elt.send_keys inputs[idx]

      wait = Selenium::WebDriver::Wait.new(:timeout => 5)
      wait.until { fillin = @driver.find_element(:name, first_name_id); fillin.enabled? }
    end

    # Drop downs
    if @driver.find_elements(:name, 'BirthMonth').size > 0
      id_list = [['BirthMonth', 'January'], ['BirthDay', '8'], ['BirthYear', '1957'], ['Gender', 'Male']]
    else
      id_list = [['iBirthMonth', 'January'], ['iBirthDay', '8'], ['iBirthYear', '1957'], ['iGender', 'Male']]
    end

    id_list.each do |pair|      
      dd_parent = @driver.find_element :name, pair[0]
      option = Selenium::WebDriver::Support::Select.new(dd_parent)
      option.select_by(:text, pair[1])
    end
  end

  def close
    @driver.quit
  end
end

if ARGV.size == 0
  puts "Need a number to initialize the Yahoo account password with. Check passwords.txt"
else
  sbot=SeleniumBot.new ARGV[0]
  sbot.sign_up
end
#sbot.close



