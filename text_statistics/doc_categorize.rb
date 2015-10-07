require 'pry'
require './text_stats'

f = Dir.glob(File.join('inputs', 'training', '*'))

doc_universe = TextStats::DocumentUniverse.new

t = TextStats::DocumentModel.new 'inputs/beer-1.txt'
puts t.counts; exit -1

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

test_vec = TextStats::DocumentModel.new(File.open(ARGV[0]).readlines.join(''))

score = 0
models.keys.each do |k|
  final_score = (models[k].inject(0) do |acc, m|
                   puts "--- #{m.explanation(test_vec, doc_universe)}"
                   acc += m.cosine_sim(test_vec, doc_universe)
                   acc
                 end)/models[k].length
  print "#{final_score}\t"
end
puts
