# Specialized script to generate ad copy for ad words campaigns

# Give a directory that has numbered files (starting with the format \d+_) for each set of words

require 'my_utilities'
require 'pry-debugger'

class Combiner
  @level = MyUtilities::Logger::FATAL
  @logger=MyUtilities::Logger.new(@level)

  class << self
    attr_accessor :logger, :level
  end

  def initialize(dir)
    entry_dir = ARGV[0]
    @file_list = (Dir.entries entry_dir).map { |f| File.join entry_dir, f}
    @logger = self.class.logger
  end

  def create_seqs seqs
    # word_lists will be a hash indexed by number  with each entry being an array of words
    final_list = []
    word_lists = read_files @file_list
    @logger.debug word_lists

    if word_lists == nil
      MyUtilities.error_exit 'Something wrong with file list'
    end

    seqs.each do |seq|
      copy_list = []

      # Dynamic programming!
      seq.each do |key|
        copy_list = cross_prod copy_list, word_lists[key.to_i]
      end
      @logger.debug "Adding ---\n#{copy_list}\n---"
      final_list |= copy_list

    end

    return final_list
  end

  private
  def cross_prod a, b
    return b if a.empty?
    return a if b.empty?

    ret_array = []
    a.each do |word1|
      next if /^\s*$/.match word1
      b.each do |word2|
        next if /^\s*$/.match word2
        ret_array << word1 + ' ' + word2
      end
    end

    ret_array
  end

  def read_files flist
    # If any of the files are mis named this will return nil
    return nil if !flist || flist.empty?
    ok=true

    flist.each do |fname|
      @logger.debug("Ok: #{ok} -> #{fname}");
      ok=ok && ((!File.file? fname) || !(/\/\d+_[^\/]*$/.match(fname).nil?))
    end
    return nil unless ok

    ret_list = {}
    flist.each do |f|
      @logger.debug f
      if File.file? f
        # The file has to start with NN_
        match_grp = /\/(\d+)_[^\/]*$/.match f
        return nil if match_grp.size != 2
        
        key = match_grp[1].to_i
        ret_list[key]=[]
        
        File.open(f).readlines.map {|word| word.chomp!; ret_list[key] << word}
      end
    end      

    if ret_list.empty?
      return nil
    else
      return ret_list
    end
  end
end

# Specify the combination sequences

seqs = [ [1,3,4,5], [2,3,4], [3,4,5], [1,3,5]]
# seqs = [ [1,2] ]

if !Dir.exists? ARGV[0]
  MyUtilities.error_exit("Supply a directory with files as first arg")
end

if ARGV.size < 2
  MyUtilities.error_exit("Need at least one sequence number")
end

c=Combiner.new ARGV[0]
seqs=ARGV[1..-1]

all_words = c.create_seqs [seqs]

puts (all_words.sort { |a, b| if a.size == b.size then ret= a<=>b else ret= a.size <=> b.size end; ret}).reject { |x| x.size > 60}

#puts all_words
