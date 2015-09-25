require 'my_utilities'
require 'getoptlong'

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--length', '-l', GetoptLong::REQUIRED_ARGUMENT],
  [ '--type', '-t', GetoptLong::REQUIRED_ARGUMENT]
)

length=20
type='alphanum'

opts.each do |opt, arg|
  case opt
  when '--help'
    MyUtilities.print_help_and_exit

  when '--length'
    length = arg.to_i

  when '--type'
    type = arg.to_s

  end
end

force_special = false
char_array = (?A..?Z).to_a + (?0..?9).to_a + (?a..?z).to_a 

case type
  when 'hex'
    char_array = (?a..?f).to_a + (?0..?9).to_a

  when 'force-special'
    force_special = true

end

if force_special
  char_array = char_array + ['!', '@', '#', '$', '%', '^', '&', '*', '(', ')']
end

api_string = length.times.inject("") {|s, i| s << char_array[rand(char_array.length)]}

print api_string
print "\n"
