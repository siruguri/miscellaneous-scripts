require 'YAML'
require "selenium-webdriver"

words = File.open('/usr/share/dict/words').readlines

driver = Selenium::WebDriver.for :firefox
driver.navigate.to "http://login.live.com/"

data = YAML.load_file 'passwords.txt'

elt_uid = driver.find_element(:name, 'login')
elt_uid.send_keys(data['login_info'][0]['uid'])

elt_pwd = driver.find_element(:name, 'passwd')
elt_pwd.send_keys(data['login_info'][0]['pwd'])

elt_pwd.submit

sleep 8
driver.navigate.to 'http://www.bing.com/?q=start'

(1..30).each do |turn|
  sleep 5
  elt = driver.find_element :name, 'q'
  elt.clear

  random_word = words[Random.rand(100000)].chomp
  
  elt.send_keys random_word
  elt.submit
end
  
driver.quit


