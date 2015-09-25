require 'nokogiri'
require 'byebug'

page = ARGV[0] || 'sports'

#system 'wget nytimes.com'
system "wget http://www.nytimes.com/pages/#{page}/index.html"

f = (File.open 'index.html').readlines.join("\n")
d = Nokogiri::HTML.parse f

printed = {}

d.xpath('//a').each do |elt|
  if elt.attribute('href') and (link = elt.attribute('href').value) and link.scan(/\-/).length > 3
    link.gsub!(/\?.*/, '')
    unless printed[link]
      printed[link] = 1
      puts link
    end
  end
end

File.unlink 'index.html'

