if !ARGV.empty?
  pwd_length = ARGV[0].to_i
end

# If the first arg wasn't set, set it to 10
pwd_length ||= 10

char_array = (?A..?Z).to_a + (?0..?9).to_a + (?a..?z).to_a 

if ARGV and ARGV[1]
  if ARGV[1] == 'punc'
    char_array = char_array | ['!', '@', '#', '$', '%', '^', '&', '*', '(', ')']

  end
end

api_string = pwd_length.times.inject("") {|s, i| s << char_array[rand(char_array.length)]}

print api_string
print "\n"
