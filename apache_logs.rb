require 'apachelogregex'
require 'byebug'

class ApacheLogs
  def initialize
    format = '%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"'
    @parser = ApacheLogRegex.new(format)
    if ARGV.size > 1
      @lines = File.open(ARGV[1]).readlines
    else
      @lines = ['89.145.95.2 - - [14/Dec/2014:07:47:19 +0000] "GET / HTTP/1.1" 200 19353 "-" "Mozilla/5.0 (compatible; GrapeshotCrawler/2.0; +http://www.grapeshot.co.uk/crawler.php)"']
    end
  end

  def run(method)
    if self.respond_to? method
      self.send method
    else
      nil
    end
  end

  def four_04s
    @lines.each do |l|
      fields = apache_fields l
      if fields['%>s'] == '404'
        puts l
      end
    end
  end
  def two_00s
    @lines.each do |l|
      fields = apache_fields l
      if fields['%>s'] == '200'
        puts l
      end
    end
  end

  private
  def apache_fields(l)
    k=@parser.parse(l)
    k
  end
end

if ARGV.size > 0
  ApacheLogs.new.run ARGV[0]
end
