require 'httpclient'
require 'nokogiri'

# Args:
# URL
# CSS pattern

clnt = HTTPClient.new
body = clnt.get_content ARGV[0]

nok=Nokogiri::HTML::Document.parse body

root = nok.root

nok.css(ARGV[1]).each do |elt|
  if elt.respond_to? :text
    puts elt.text 
  else
    puts "<Node w/o text>"
  end
end

