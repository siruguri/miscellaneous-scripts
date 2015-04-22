require "watir-webdriver"

require 'pry-byebug'

class GenericCrawler
  attr_reader :driver
  
  def initialize
    @driver = Watir::Browser.new :phantomjs
    @words = File.open('/usr/share/dict/words').readlines
    @login_data = YAML.load_file 'passwords.txt'
  end

  def get(u)
    @driver.goto u
  end

  def response
    @driver.response
  end
end

l=GenericCrawler.new

url = ARGV[0] || 'http://www.google.com'
l.get url
puts l.driver.body.html
