require 'my_utilities'

if ARGV.size < 1
  MyUtilities.error_exit("Need at least one input file")
end

if File.exists? ARGV[1]
   File.open(ARGV[1], 'r').readlines.each do |line|

    fields = line.split
    fields[3]="#{fields[3]} #{fields[4]}"
    fields[5]="#{fields[5]} #{fields[6]} #{fields[7]}"
    fields[11]=fields[11..-1].join " "
    
    puts fields[11]
  end
else
  MyUtilities.error_exit("Can't read input file #{ARGV[1]}")
end

