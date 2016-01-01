require 'pry'

f=File.open ARGV[0], 'rb'
count =0

while !f.eof
  buf = f.read 2048
  buf.split('').each do |byte|
    out=byte

    if byte == "\r"
      out="\n"
    end

    $stdout.write out
  end
end

puts
