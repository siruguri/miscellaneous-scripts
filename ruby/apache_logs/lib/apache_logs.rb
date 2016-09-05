class ApacheLogs
  class UnknownMethodException < Exception
  end
  
  def self.allowed_methods
    [:four_04s, :two_00s].map { |i| i.to_s}
  end
  def self.method_allowed?(m)
    allowed_methods.include?(m) or allowed_methods.include?(m.to_sym)
  end
  
  def initialize
    # www.offtherailsapps.com:80 180.76.15.137 - - [04/Jul/2015:03:16:30 -0700] "GET / HTTP/1.1" 403 366 "-" "Mozilla/5.0 (compatible; Baiduspider/2.0; +http://www.baidu.com/search/spider.html)"
    format = '%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"'
    @parser = ApacheLogRegex.new(format)
    @lines = []
    
    @_404_request_url_counts = {}
    @_bad_404_requestors = {}
    @_bad_404_requestor_counts = {}
  end

  def run(method, entries, app)
    if !ApacheLogs.method_allowed?(method)
      raise UnknownMethodException.new(method)
    end

    @db_conn = app.db_conn
    @method = method

    if File.ftype(entries) == 'file'
        analyze entries
    elsif Dir.exist? entries
      Dir.entries(entries).each do |f|
        log = File.join(entries, f)
        if File.ftype(log) == 'file'
          analyze log
        end
      end
    else
      $stderr.write("Second arg #{entries} needs to be a file or dir.\n")
      exit -1
    end

    output_analysis method
  end

  def four_04s
    @lines.each do |l|
      leading_host_regex = /^[^\s]*\.com(:\d+)? /
      if leading_host_regex.match l
        l.gsub! leading_host_regex, ''
      end
      
      fields = apache_fields l
      if fields.nil?
        $stderr.write("Parser failed on #{l}\n")
      else
        if fields['%>s'] == '404' and malicious_url(fields['%r'])  and
          !(/(bot)|(spider)|(crawler)/i.match fields['%{User-Agent}i'])
          add_404_request(fields['%r'], fields['%h'])
        end
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

  def malicious_url(uri)
    !(/GET \/((blog)|(category)|(tag)|(robots)|(comments.feed)|(2\d))/).match(uri)
  end
  
  def output_analysis(method)
    if method.to_sym == :four_04s
      @_404_request_url_counts.sort do |a,b| 
        b[1] <=> a[1]
      end.each do |uri, count|
        print "#{uri} (#{count}): "
        puts @_bad_404_requestors[uri].join (', ')
      end

      puts '--- IPs by count ---'
      @_bad_404_requestor_counts.sort do |a,b|
        b[1] <=> a[1]
      end.each do |ip, count|
        puts "#{ip}: #{count}"
      end
    end
  end
  
  def analyze(entries_file)
    $stderr.write("Opening #{entries_file}\n")

    if /.gz$/.match entries_file
      @lines = Zlib::GzipReader.open(entries_file).readlines
    else
      @lines = File.open(entries_file).readlines
    end
    self.send @method
  end
  
  def apache_fields(l)
    @parser.parse(l)
  end

  def add_404_request(uri, ip)
    UriRequest.find_or_create_by uri: uri, ip: ip
    
    @_404_request_url_counts[uri] ||= 0
    @_404_request_url_counts[uri] += 1

    @_bad_404_requestors[uri] ||= []
    unless @_bad_404_requestors[uri].include? ip
      @_bad_404_requestors[uri] << ip
      @_bad_404_requestor_counts[ip] ||= 0
      @_bad_404_requestor_counts[ip] += 1
    end
  end
end
