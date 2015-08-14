# coding: utf-8
require 'byebug'

def compute_counts(word_list)
  word_counts = {}
  word_list.each do |word|
    word_counts[word] ||= 0
    word_counts[word] += 1
  end
  word_counts
end

def compute_frequencies(word_list)
  word_counts = {}

  word_list.each do |word|
    word_counts[word] ||= 0
    word_counts[word] += 1
  end

  word_list_size_f = word_list.size.to_f
  word_counts.each do |w, c|
    word_counts[w] = c / word_list_size_f
  end
  
  word_counts
end

def words(body)
  # return all the words in the text that's in the argument body
  body.gsub(/’/, "'").split(/[^a-zA-Z0-9']+/).map(&:downcase).select{ |w| !stop_words.include?(w) }
end

def stop_words
  %w(a able it's about above abst accordance according accordingly across act actually added adj affected affecting affects after afterwards again against ah all almost alone along already also although always am among amongst an and announce another any anybody anyhow anymore anyone anything anyway anyways anywhere apparently approximately are aren arent arise around as aside ask asking at auth available away awfully b back be became because become becomes becoming been before beforehand begin beginning beginnings begins behind being believe below beside besides between beyond biol both brief briefly but by c ca came can cannot can't cause causes certain certainly co com come comes contain containing contains could couldnt d date did didn't different do does doesn't doing done don't down downwards due during e each ed edu effect eg eight eighty either else elsewhere end ending enough especially et et-al etc even ever every everybody everyone everything everywhere ex except f far few ff fifth first five fix followed following follows for former formerly forth found four from further furthermore g gave get gets getting give given gives giving go goes gone got gotten h had happens hardly has hasn't have haven't having he hed hence her here hereafter hereby herein heres hereupon hers herself hes hi hid him himself his hither home how howbeit however hundred i id ie if i'll im immediate immediately importance important in inc indeed index information instead into invention inward is isn't it itd it'll its itself i've j just k keep keeps kept kg km know known knows l largely last lately later latter latterly least less lest let lets like liked likely line little ll look looking looks ltd m made mainly make makes many may maybe me mean means meantime meanwhile merely mg might million miss ml more moreover most mostly mr mrs much mug must my myself n na name namely nay nd near nearly necessarily necessary need needs neither never nevertheless new next nine ninety no nobody non none nonetheless noone nor normally nos not noted nothing now nowhere o obtain obtained obviously of off often oh ok okay old omitted on once one ones only onto or ord other others otherwise ought our ours ourselves out outside over overall owing own p page pages part particular particularly past per perhaps placed please plus poorly possible possibly potentially pp predominantly present previously primarily probably promptly proud provides put q que quickly quite qv r ran rather rd re readily really recent recently ref refs regarding regardless regards related relatively research respectively resulted resulting results right run s said same saw say saying says sec section see seeing seem seemed seeming seems seen self selves sent seven several shall she shed she'll shes should shouldn't show showed shown showns shows significant significantly similar similarly since six slightly so some somebody somehow someone somethan something sometime sometimes somewhat somewhere soon sorry specifically specified specify specifying still stop strongly sub substantially successfully such sufficiently suggest sup sure than that that's the their theirs them themselves then there there's these they they'd they'll they're they've this those through to too under until up very was wasn't we we'd we'll we're we've were weren't what what's when when's where where's which while who who's whom why why's will with won't would wouldn't x you you'd you'll you're you've your yours yourself yourselves)
end

def dot_product(a, b)
  common_keys = a.keys & b.keys

  dot_product = common_keys.inject(0) do |memo, k|
    memo += a[k] * b[k]
    memo
  end
end

def sorted_dot_product_counts(a, b)
  common_keys = a.keys & b.keys
  counts = common_keys.map do |k|
    [k, a[k] * b[k]]
  end

  counts.sort do |a, b|
    b[1] <=> a[1]
  end
end

def magnitude(a)

  sqr_mag = a.inject(0) do |memo, h|
    memo += h[1] * h[1]
  end

  Math.sqrt(sqr_mag)
end

def cosine_sim(a, b)
  dot_product(a, b)/(magnitude(a) * magnitude(b))
end

$stdout.write("Document 1: ")
sort_list = list.sort do |a, b|
  counts_1[b] <=> counts_1[a]
end
sort_list.uniq[0..9].each do |word|
  $stdout.write("#{word}, ")
end
puts

body = File.open(ARGV[0]).readlines.join('')
list = words body
counts_1 = compute_frequencies list

body = File.open(ARGV[1]).readlines.join('')
list = words body

counts_2 = compute_frequencies list
$stdout.write("Document 2: ")
sort_list = list.sort do |a, b|
  counts_2[b] <=> counts_2[a]
end
sort_list.uniq[0..9].each do |word|
  $stdout.write("#{word}, ") 
end
puts

puts "Similarity is #{cosine_sim(counts_1, counts_2)}"

sort_list = sorted_dot_product_counts(counts_1, counts_2)

puts "Terms by commonality frequency are"
sort_list[0..9].each do |word_count|
  $stdout.write("#{word_count[0]}, ") # #{word_count[1]}"
end
puts

