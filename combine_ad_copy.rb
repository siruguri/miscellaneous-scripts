# Specialized script to generate ad copy for ad words campaigns

# Give a directory that has numbered files (starting with the format \d+_) for each set of words

require 'my_utilities'
require 'pry'
require 'getoptlong'

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--sequences-file', '-s', GetoptLong::REQUIRED_ARGUMENT],
  [ '--kwd-dir', '-k', GetoptLong::REQUIRED_ARGUMENT],
  [ '--ad-group-prefix', '-p', GetoptLong::REQUIRED_ARGUMENT],
  [ '--output-directory', '-d', GetoptLong::REQUIRED_ARGUMENT]
)

class Combiner
  @level = MyUtilities::Logger::FATAL
  @logger=MyUtilities::Logger.new(@level)

  class << self
    attr_accessor :logger, :level
  end

  def initialize(entry_dir)
    @file_list = (Dir.entries entry_dir).map { |f| File.join entry_dir, f}
    @logger = self.class.logger
  end

  def create_seqs seqs
    # word_lists will be a hash indexed by number  with each entry being an array of words
    final_list = []
    word_lists = read_files @file_list
    @logger.debug word_lists

    if word_lists.nil?
      MyUtilities.error_exit 'Something wrong with file list - no filename matched the pattern NN_<blah>.txt. Maybe you forgot the underscore?'
    end

    seqs.each do |seq|
      copy_list = []

      # Dynamic programming!
      seq.each do |key|
        if word_lists[key.to_i].nil?
          MyUtilities.error_exit "Sequences required a file starting with #{key.to_i}_, but that doesn't exist."
        end
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
        ret_array << word1.downcase + ' ' + word2.downcase
      end
    end

    ret_array
  end

  def read_files flist
    # If any of the files are mis named this will return nil

    @logger.debug("Received #{flist} in read_files")

    return nil if !flist || flist.empty?
    ok=false

    # check there's at least one file starting with numbers
    flist.each do |fname|
      break if ok
      @logger.debug("Ok: #{ok} -> #{fname}");
      condition_check = (File.file?(fname) && !(/\/\d+_[^\/]*$/.match(fname).nil?))
      ok=(ok || condition_check) 
    end
    return nil unless ok

    ret_list = {}
    flist.each do |f|
      if File.file? f
        # The file has to start with NN_
        match_grp = /\/(\d+)_[^\/]*$/.match f
        next unless match_grp && match_grp.size == 2
        
        key = match_grp[1].to_i
        ret_list[key]=[]
        
        File.open(f).readlines.map do |word|
          word.chomp!
          word.gsub! /[^a-zA-Z0-9]+/, ' '
          ret_list[key] << word
        end
      end
    end      

    if ret_list.empty?
      return nil
    else
      return ret_list
    end
  end
end

kwd_dir = sequences_file = nil
output_dir = '.'
ad_grp_prefix = 'trial ads'

def help
  MyUtilities.error_exit("Supply a directory with files with --kwd-dir/-k; a filename containing sequences or a list of seqs each as a quoted string with --sequences-file/-s; the ad group prefix optionally with --ad-group-prefix/-p; the output directory with --output-directory/-d")
end

opts.each do |opt, arg|
  case opt
  when '--help'
    help

  when '--kwd-dir'
    kwd_dir = arg
    
  when '--sequences-file'
    sequences_file = arg

  when '--ad-group-prefix'
    ad_grp_prefix = arg

  when '--output-directory'
    if !Dir.exists? arg
      MyUtilities.error_exit "Option to -d/--output-directory is not a directory"
    end
    output_dir = arg
  end
end

if kwd_dir.nil? or (sequences_file.nil? && ARGV.length == 0) or
  (sequences_file.is_a? String and (!File.exists? sequences_file))
  help
end

if sequences_file.nil?
  sequences_file = ARGV[0..-1]
end

if sequences_file.is_a? String
  all_seqs=[]
  # Expect each line to be single space separated numbers
  open(sequences_file).readlines.map do |line|
    all_seqs.push(line.split(' '))
  end
else
  all_seqs = [sequences_file]
end  

c=Combiner.new kwd_dir
slice_size = 19000

# Break down the outputs into individual files for upload
all_seqs.each do |seqs|
  all_words = c.create_seqs [seqs]
  iterations = all_words.size / slice_size

  (0..iterations).each do |iter_index|
    slice_end = [all_words.size, slice_size * (iter_index + 1)].min - 1
    slice_beg = slice_size * iter_index
    out_f = File.open File.join(output_dir, "#{iter_index}.kwds.tsv"), 'w'
    out_f.puts "Keyword state	Keyword	Match type	Campaign	Ad group	Status	Keyword max CPC	Ad group max CPC	Destination URL	Campaign type	Campaign subtype	Clicks	Impressions	CTR	Avg. CPC	Cost	Avg. position	Labels"
    
    all_words[slice_beg..slice_end].sort do |a, b|
      if a.size == b.size
        a<=>b
      else
        ret= a.size <=> b.size
      end
    end.each do |x|
      unless x.size > 60
        out_f.puts "enabled	#{x}	Broad	Citiz Audit	#{ad_grp_prefix}.#{iter_index}	campaign paused	0.60	0.10		Search Only	Standard	0	0	0.00%	0.00	0.00	0.0	 --"
      end
    end

    out_f.close
  end
end


