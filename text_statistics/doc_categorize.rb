require 'pry'
require './text_stats'

def make_universe
  doc_universe = TextStats::DocumentUniverse.new
  mr_files = Dir.glob "inputs/training/musicreviews/1/*txt"
  sp_files = Dir.glob "inputs/training/sports/1/*txt"
  sc_files = Dir.glob "inputs/training/science/1/*txt"
  univ_files = Dir.glob "inputs/training/universe/*txt"
    
  (univ_files + mr_files + sp_files + sc_files).each do |f|
    doc_universe.add TextStats::DocumentModel.new f
  end

  doc_universe
end

def print_data(f1, f2, t1, t2, scores, doc_universe)
#  puts "Magnitudes for #{f1}/#{f2}: #{t1.magnitude}, #{t2.magnitude}"
  puts scores[f1 + '.' + f2].score
  if scores[f1 + '.' + f2].score.to_s.match '0.25413'
    binding.pry
  end
  # puts scores[f1 + '.' + f2].explanation(universe: doc_universe)
end

def get_in_scores(doc_universe)
  in_scores = {}

  mr_files = Dir.glob "inputs/training/musicreviews/1/*txt"
  sp_files = Dir.glob "inputs/training/sports/1/*txt"
  sc_files = Dir.glob "inputs/training/science/1/*txt"
  [mr_files, sp_files, sc_files].each do |set|
    set.each do |f1|
      set.each do |f2|
        if f1 != f2 and (in_scores[f1 + '.' + f2].nil? || in_scores[f2 + '.' + f1].nil?)
          t1 = TextStats::DocumentModel.new f1
          t2 = TextStats::DocumentModel.new f2

          t1.universe = doc_universe
          t2.universe = doc_universe

          in_scores[f1 + '.' + f2] = t1.cosine_sim(t2)
          in_scores[f2 + '.' + f1] = in_scores[f1 + '.' + f2]

          print_data f1, f2, t1, t2, in_scores, doc_universe unless in_scores[f1 + '.' + f2].score.to_s == 'NaN'
        end
      end
    end
  end
end

def get_out_scores(doc_universe)
  out_scores = {}

  mr_files = Dir.glob "inputs/training/musicreviews/1/*txt"
  sp_files = Dir.glob "inputs/training/sports/1/*txt"
  sc_files = Dir.glob "inputs/training/science/1/*txt"
  [[mr_files, sp_files], [mr_files, sc_files], [sc_files, sp_files]].each do |set_pair|
    set_pair[0].each do |f1|
      set_pair[1].each do |f2|
        if f1 != f2 and (out_scores[f1 + '.' + f2].nil? || out_scores[f2 + '.' + f1].nil?)
          t1 = TextStats::DocumentModel.new f1
          t2 = TextStats::DocumentModel.new f2

          out_scores[f1 + '.' + f2] = t1.cosine_sim(t2)
          out_scores[f2 + '.' + f1] = out_scores[f1 + '.' + f2]

          print_data f1, f2, t1, t2, out_scores, doc_universe unless out_scores[f1 + '.' + f2].score.to_s == 'NaN'
        end
      end
    end
  end
end

d = make_universe
get_in_scores d
#get_out_scores d

exit -1
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
