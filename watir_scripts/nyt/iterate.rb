found = {}
loc = File.dirname(File.expand_path __FILE__)
File.open(ARGV[0]).readlines.each_with_index do |l, idx|
  l.chomp!
  k = l.gsub(/\?.*$/, '')

  unless found[k]
    found[k] = true
    puts "ruby #{loc}/crawl.rb #{k} #{idx}.txt"
    puts "sleep 20"
  end
end
