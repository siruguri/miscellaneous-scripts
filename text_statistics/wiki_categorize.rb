require 'byebug'
require './text_stats'
require 'nokogiri'
require 'open-uri'
require 'readability_parser'

f = Dir.glob(File.join('inputs', 'training', 'sports*'))

class ReadabilityWrapper
  def initialize
    @_key = ENV['READABILITY_API_KEY']
    @_client = ReadabilityParser::Client.new(api_token: @_key)
  end

  def parse(uri)
    @_client.parse(uri)
  end
  alias :extract :parse
end

doc_universe = TextStats::DocumentUniverse.new

models = {}
f.entries.each do |k|
  if Dir.exist? k
#    puts "Building vectors for #{File.basename(k)} documents"
    models[k]=[]
    
    Dir.glob(File.join(k, '**', '*.txt')).entries.each_with_index do |file, index|
      if File.exists?(file) #&& index < 4
        input = File.open(file).readlines.join(' ')
        if input.strip.size > 0
          models[k] << TextStats::DocumentModel.new(input)

          doc_universe.add(models[k].last)
        end
      end
    end
  end
end

#dom = Nokogiri::HTML.parse(open('http://en.wikipedia.org/wiki/Science').readlines.join(''))
dom = Nokogiri::HTML.parse(open(ARGV[0]).readlines.join(''))

links = dom.css 'a'

links.each do |elt|
  if /^\/wiki\/[^:\/]+$/.match(elt.attribute('href'))
    print "#{elt.attribute('href')}: "
    readability_obj = ReadabilityWrapper.new.extract ('http://en.wikipedia.org' + elt.attribute('href'))

    test_vec = TextStats::DocumentModel.new(readability_obj.content, as_html: true)

    models.keys.each do |k|
      final_score = (models[k].inject(0) do |acc, m|
                       acc += m.cosine_sim(test_vec, doc_universe)
                       acc
                     end)/models[k].length
      puts "#{final_score}"
    end
    sleep 1
  end
end

