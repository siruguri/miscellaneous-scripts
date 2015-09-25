f=File.open ARGV[0], 'rb'
count =0
in_quote=false
while !f.eof
  buf = f.read 2048
  buf.split('').each do |byte|
    out=byte
    if byte == '"'
      in_quote=!in_quote
    elsif byte == ','
      if !in_quote
        out="\t"
      end
    end
    $stdout.write out

    count += 1


  end
end
