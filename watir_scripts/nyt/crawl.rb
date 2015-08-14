require 'watir-webdriver'
require 'headless'

headless = Headless.new
headless.start

filename = File.join("nytouts", ARGV[1])
out_h = File.open filename, 'w'

b = Watir::Browser.new :phantomjs
b.goto ARGV[0]

begin
  try_text = b.article(class: 'post').text
rescue Watir::Exception::UnknownObjectException => e
  all_ps = b.ps(class: 'story-body-text')
  try_text = ''
  all_ps.each { |elt| try_text += elt.text; try_text += "\n" }
end

out_h.puts try_text
out_h.close

headless.destroy
