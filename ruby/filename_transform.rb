# Replace one char with another
# format: <filename> <char1> <char2>

exit -1 if (!File.exists?(ARGV[0]))
c1 = ARGV[1]
c2 = ARGV[2]

exit -1 if c1.nil? || c2.nil?

c1 = c1[0]
c2 = c2[0]

name = ARGV[0]
newname = name.gsub c1, c2
File.rename name, newname
