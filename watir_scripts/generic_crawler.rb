require "watir-webdriver"

require 'pry-byebug'

class LiveLogin
  attr_reader :driver
  
  def initialize
    @driver = Watir::Browser.new :phantomjs
    @words = File.open('/usr/share/dict/words').readlines
    @login_data = YAML.load_file 'passwords.txt'
  end

  def get(u)
    @driver.goto u
  end
end

l=LiveLogin.new
byebug

l.get('http://mobile.nytimes.com/2015/03/22/opinion/sunday/how-english-ruined-indian-literature.html')

puts l.response.body
