require 'watir'

browser = Watir::Browser.new

browser.goto ARGV[0] || 'watir.com'
puts 'hit enter'
$stdin.gets
browser.link(text: 'Guides').click

puts browser.title
browser.close
