require 'headless'
require 'watir-webdriver'
require 'byebug'

headless = Headless.new
headless.start


filename = File.join("nytouts", ARGV[1])
out_h = File.open filename, 'w'

driver = Watir::Browser.new

driver.goto ARGV[0]
#byebug

begin
  try_text = driver.article(class: 'post').text
rescue Watir::Exception::UnknownObjectException => e
  all_ps = driver.ps(class: 'story-body-text')
  try_text = ''
  all_ps.each { |elt| try_text += elt.text; try_text += "\n" }
end

out_h.puts try_text
out_h.close

headless.destroy
