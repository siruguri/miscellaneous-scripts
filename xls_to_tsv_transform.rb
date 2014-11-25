require 'rubyXL'
# became necessary because XLS on OSX does stupid stuff to utf 8 encoding

workbook = RubyXL::Parser.parse(ARGV[0])
sheet = workbook.worksheets[0] # Returns first worksheet

sheet.sheet_data.each do |row|
  row.each do |cell|
    puts "#{cell}\t"
  end
end

