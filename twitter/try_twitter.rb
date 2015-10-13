require 'twitter'
require 'pry'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "qaqpdnACK24BRiFYIMg3Wg"
  config.consumer_secret     = "NrnjdoTXSFFbAAmdd7Q9tvq1hblkXvSKzp2m9n38"
  config.access_token        = "5036831-ESqfXH5D0tHTCTMKgCDiE4oqZ2kj8eNVdRTzmKNgXE"
  config.access_token_secret = "RQh8yxkBToojsDslQyTLTmzG2cDui8JYd2ZjcyRLte4yw"
end

cursor = "-1"
binding.pry
followers = Twitter.followers "IDTOLOOKUP", {cursor: cursor}
client.user_timeline(count: 10).each_with_index do |tweet, idx|
  puts "##{idx}: #{tweet.id}: #{tweet.full_text}"
end
client.user_timeline(count: 10, max_id: 521352250384719874).each_with_index do |tweet, idx|
  puts "##{idx}: #{tweet.id}: #{tweet.full_text}"
end

