require 'net/http'
require 'date'

found = {}
loc = File.dirname(File.expand_path __FILE__)

def err(str)
  $stderr.write "#{str}\n"
end

# http://www.nytimes.com/2015/08/12/business/international/china-renminbi-currency-devaluation.html
while(1) do
  d=Date.today
  out_folder = "#{d.month}.#{d.day}"
  xml_str = Net::HTTP.get URI('http://rss.nytimes.com/services/xml/rss/nyt/AsiaPacific.xml')

  matches = xml_str.scan(/link.href..([^"]*nytimes.com.20\d\d[^\?]*.html)\?/)

  err(matches.size)
  matches[1..-1].each_with_index do |url, idx|
    err(url)
    if !Dir.exist?("nytouts/#{out_folder}")
      Dir.mkdir "nytouts/#{out_folder}"
    end
    cmd = "ruby #{loc}/crawl.rb #{url[0]} #{out_folder}/#{idx}.txt"
    puts cmd
    #system cmd
  end
  exit -1
  sleep 86400
end
