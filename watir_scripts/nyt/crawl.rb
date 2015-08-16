require 'watir-webdriver'
require 'headless'
require 'pry'

headless = Headless.new
headless.start

filename = File.join("nytouts", ARGV[1])
out_h = File.open filename, 'w'

b = Watir::Browser.new :phantomjs

nyt_article=''
b.goto 'https://www.google.com/search?q=kim+ryen+hi+south+korea+defection'
b.as.each do |goog_result|
  if /url\?.*nytimes/.match(goog_result.href)
    puts goog_result.href, goog_result.text
    nyt_article = goog_result.href
  end
end

#nyt_article = ARGV[0]
b.goto nyt_article

begin
  try_text = b.article(:class => 'post').text
  a=1
rescue Watir::Exception::UnknownObjectException => e
  
  all_ps = b.ps
  try_text = ''
  all_ps.each_with_index do |elt, idx|
    begin
      puts "#{idx}: #{elt.text[0..120]}"
      try_text += elt.text
      try_text += "\n"
    rescue Watir::Exception::UnknownObjectException => f
    end
  end
end

out_h.puts try_text
out_h.close

headless.destroy
