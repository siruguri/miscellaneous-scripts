require 'rubyXL'
# became necessary because XLS on OSX does stupid stuff to utf 8 encoding

workbook = RubyXL::Parser.parse(ARGV[0])
data = workbook[0].extract_data # Returns first worksheet

data.each do |row|
  if row
    row.each do |cell|
      print "#{cell}\t"
    end
    puts
  end
end

