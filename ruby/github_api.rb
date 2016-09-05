#usage: ruby github_api.rb login:password otp
# https://api.github.com/issues?state=closed&labels=201605' > 201605_issues.json

require 'date'
require_relative '../../ruby/patterns/net_http_fetch.rb'

n1 = NetHttpFetch.new uri: 'https://api.github.com/repos/Qvivr/web/issues?state=closed&labels=201606'

# create a new personal access token below, from ~/records/passwords/github_pac.text

f=File.open('/Users/sameer/records/passwords/github_pac.text', 'r')
pwd = f.readlines[0].chomp

n1.basic_auth username: 'siruguri', password: pwd
resp = n1.get

j = resp[:body].to_json
list = j.sort_by { |l| DateTime.strptime(l['created_at'], '%Y-%m-%d')}.map { |l| "#{l['title']}\t#{l['created_at']}\n"}
list.each do |l|
  print l
end

