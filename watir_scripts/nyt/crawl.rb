# coding: utf-8

require 'yaml'
require 'watir-webdriver'
require 'headless'
require 'nokogiri'
require 'pry'
require 'net/http'

headless = Headless.new
headless.start

if ARGV.size < 1
  $stderr.write 'Need an output file as the first arg.'
  exit -1
end

filename = File.join("nytouts", ARGV[0])
out_h = File.open filename, 'w'

def err(m)
  $stderr.write m+"\n"
end
  
def stop_words
  %w(a able it's about above abst accordance according accordingly across act actually added adj affected affecting affects after afterwards again against ah all almost alone along already also although always am among amongst an and announce another any anybody anyhow anymore anyone anything anyway anyways anywhere apparently approximately are aren arent arise around as aside ask asking at auth available away awfully b back be became because become becomes becoming been before beforehand begin beginning beginnings begins behind being believe below beside besides between beyond biol both brief briefly but by c ca came can cannot can't cause causes certain certainly co com come comes contain containing contains could couldnt d date did didn't different do does doesn't doing done don't down downwards due during e each ed edu effect eg eight eighty either else elsewhere end ending enough especially et et-al etc even ever every everybody everyone everything everywhere ex except f far few ff fifth first five fix followed following follows for former formerly forth found four from further furthermore g gave get gets getting give given gives giving go goes gone got gotten h had happens hardly has hasn't have haven't having he hed hence her here hereafter hereby herein heres hereupon hers herself hes hi hid him himself his hither home how howbeit however hundred i id ie if i'll im immediate immediately importance important in inc indeed index information instead into invention inward is isn't it itd it'll its itself i've j just k keep keeps kept kg km know known knows l largely last lately later latter latterly least less lest let lets like liked likely line little ll look looking looks ltd m made mainly make makes many may maybe me mean means meantime meanwhile merely mg might million miss ml more moreover most mostly mr mrs much mug must my myself n na name namely nay nd near nearly necessarily necessary need needs neither never nevertheless new next nine ninety no nobody non none nonetheless noone nor normally nos not noted nothing now nowhere o obtain obtained obviously of off often oh ok okay old omitted on once one ones only onto or ord other others otherwise ought our ours ourselves out outside over overall owing own p page pages part particular particularly past per perhaps placed please plus poorly possible possibly potentially pp predominantly present previously primarily probably promptly proud provides put q que quickly quite qv r ran rather rd re readily really recent recently ref refs regarding regardless regards related relatively research respectively resulted resulting results right run s said same saw say saying says sec section see seeing seem seemed seeming seems seen self selves sent seven several shall she shed she'll shes should shouldn't show showed shown showns shows significant significantly similar similarly since six slightly so some somebody somehow someone somethan something sometime sometimes somewhat somewhere soon sorry specifically specified specify specifying still stop strongly sub substantially successfully such sufficiently suggest sup sure than that that's the their theirs them themselves then there there's these they they'd they'll they're they've this those through to too under until up very was wasn't we we'd we'll we're we've were weren't what what's when when's where where's which while who who's whom why why's with won't would wouldn't x you you'd you'll you're you've your yours yourself yourselves)
end

def get_xml(url)
  err "Getting XML feed for #{url}"
  str = Net::HTTP.get URI(url)
  dom = Nokogiri::XML.parse str
end

if File.exists? 'config.yml'
  config = YAML.load_file 'config.yml'
else
  config = nil
end

def get_config(cfg, key, default)
  if cfg and (cfg[key.to_s] or cfg[key])
    cfg[key] || cfg[key.to_s]
  else
    default
  end
end
    
xml_descriptions = get_xml get_config(config, :rss_xml, 'http://rss.nytimes.com/services/xml/rss/nyt/AsiaPacific.xml')

def extract_nyt_link(b, url)
  b.goto url

  err 'Looking for News Answer'
  phantom_links = b.div(css: '._yE').as.select { |l| /www.google.com.url.q=http...www.nytimes.com/.match(l.attribute_value('href')) }

  if phantom_links.size > 0
    phantom_links[0]
  else
    err 'Looking in organic results'
    elt = b.a(css: '._Dk')
    unless elt.exists?
      elt = b.divs(:css => ".srg .g")[0].as[0]
    end
    elt
  end
end

def get_target_dir
  t = Date.today
  File.join('nytouts', sprintf("%04d-%02d-%02d", t.year, t.month, t.day))
end

def get_nyt_content(b, link)
  target_dir = get_target_dir

  link.click
  try_text = ''

  begin
    try_text = b.article(:class => 'post').text
    a=1
  rescue Watir::Exception::UnknownObjectException => e
    err "No post class div in NYT article HTML"
    all_ps = b.ps

    all_ps.each_with_index do |elt, idx|
      begin
        err "#{idx}: #{elt.text[0..120]}"
        try_text += elt.text
        try_text += "\n<p>"
      rescue Watir::Exception::UnknownObjectException => f
        err "No text element in paragraph."
      end
    end
  end

  try_text
end

def href_to_filename(link)
  match =  /\/(([^\?\/]+)[^\/]*$)/.match(link.attribute_value 'href')
  filename = match[2]
  filename.gsub!(/[^a-zA-Z0-9]/, '_')

  if /_html$/.match filename
    filename.gsub!(/_html$/, '.html')
  else
    filename += '.html'
  end

  filename
end  

target_dir = get_target_dir
unless Dir.exists? target_dir
  Dir.mkdir target_dir
end

b = Watir::Browser.new #:phantomjs
fetched_counter = 0

# Hard codes structure of NYT's feed's atom (which should be about the same as any other RSS format)
xml_descriptions.children[1].children[0].children.each do |item|
  if item.children[1] and item.children[1].name == 'title'
    query = (item.children[1].children[0].text.downcase.split(/\s+/).uniq - stop_words)[0..3].join('+')

    link = extract_nyt_link b, "https://www.google.com/search?q=nyt+#{query}"
    outfile = target_dir + "/" + href_to_filename(link)
    err "Getting NYT link from Google search page to write to #{outfile}"

    unless File.exists? outfile
      fh = File.open outfile, 'w'
      begin
        content = get_nyt_content b, link
        fh.write content
        fh.close
        # My Internet connection sucks!
      rescue Net::ReadTimeout => e
        err "Timed out. Moving on."
      ensure
        fetched_counter += 1
        if fetched_counter == 10
          b.close
          fetched_counter = 0
          b = Watir::Browser.new
        end
      end        
    else
      err "Skipping. File exists"
    end
    
    sleep 5
  end
end
b.close

