# links on page l1['data']['children'][2]['data']['id']
# comments l1[1]['data']['children'][0]['data']['replies']

require 'pry'
require 'net/http'
require 'json'

class RedditData
  def initialize
    @pg = ARGV[0] || 'https://www.reddit.com/r/news.json'
  end

  def run
    json_body(@pg).each_with_index do |item, idx|
      id = item['data']['id']
      $stderr.puts "Reading URL #{idx}: ID #{id}"
      u = "https://www.reddit.com/r/news/comments/#{id}.json"

      @file_idx = idx
      dump_comments u
      sleep 2
    end
  end

  private
  # Returns an array of items
  def json_body(u)
    g = JSON.parse(Net::HTTP.get(URI(u)))

    if g.is_a? Hash
      f = g['data']['children']
    else
      f = g[1]['data']['children']
    end
    f
  end
  def parse_comment_tree(comment_array, level=0)
    comment_array.each do |item|
      next if item['kind'] == 'more'
      # Ignoring the more link for now
      
      @_fh.puts ("  " * level) + item['data']['body']

      unless item['data']['replies'].empty?
        parse_comment_tree item['data']['replies']['data']['children'], level + 1
      end
    end
  end
  def dump_comments(u)
    @_fh = open("/Users/sameer/code/scripts/text_statistics/inputs/training/universe/#{sprintf("%03d", @file_idx)}.txt", 'w')
    parse_comment_tree json_body(u)
    @_fh.close
  end

end
RedditData.new.run
