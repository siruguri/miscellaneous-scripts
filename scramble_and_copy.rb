# Scramble a list of files and copy in order
# input dir = cmd arg 1
# copy to dir = cmd arg 2
# unique id = cmd arg 3

require 'fileutils'
in_list = Dir.entries ARGV[0]
copy_to = ARGV[1]

if ARGV[2].nil?
  uniq_id = (Random.rand*65+1).ceil.to_s
else
  uniq_id = ARGV[2]
end

r = Range.new(0, in_list.count-1)
rand_r = r.to_a.shuffle

ctr = 0
rand_r.each do |x|
  entry = File.join(ARGV[0], in_list[x])
  if File.file?(entry) && !/^\./.match(in_list[x]) then
    rets=/\.([^\.]+)$/.match(in_list[x])
    ext=rets[1]
    FileUtils.cp "#{entry}", "#{copy_to}/#{uniq_id}-#{ctr}.#{ext}"

    ctr += 1
  end
end
