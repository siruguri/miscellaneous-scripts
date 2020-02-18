require 'pry'
# Use as a pattern
# to select files to act on, give glob as first arg; RUN IN THE FOLDER THE FILES ARE IN

Dir.glob(ARGV[0]).each do |file|
  match = /([^\/]*)_rmledg(_(.*))?/.match(file)
  binding.pry if match.nil?
  
  newname =
    if !match[3].nil?
      "rmledg_#{match[1]}_#{match[3]}"
    else
      "rmledg_#{match[1]}.csv"
    end
  puts newname
  File.rename file, newname
end

