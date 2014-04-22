# This script will add col- classes that are not already there.
# The input file should be in stdin

lines = STDIN.readlines

lines.each do |line| 

  match_string = 'col.(..).(\d{1,2})'

  rx = Regexp.new(match_string)
  m = rx.match(line)
  
  if m 
    if m[1]=='sm'
      others=['lg', 'md'] 
    else
      others=['md', 'sm'] 
    end

    new_s = others.map { |cl| "col-#{cl}-#{m[2]}" }.join " "
    new_s += " col-#{m[1]}-#{m[2]}"

    line=line.sub(rx, new_s)
  end

  puts line
end
