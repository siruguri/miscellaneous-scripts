# This one is more recent and uses the google-drive-ruby gem.

require "rubygems"
require "google_drive"

begin
  session = GoogleDrive.login("siruguri@gmail.com", "rzsjhukaqsxrdgbt")
rescue AuthenticationError => ex
  puts "Auth failed: #{ex.message}"
end


# First worksheet of
# https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
ws = session.spreadsheet_by_key("1gYJz-SBtbM9rFomO1EWCFSkfVeUCTAqDG9TQ8o31j4I").worksheets[0]

puts "A2: #{ws[1, 2]}"
puts "D10: #{ws[10, 4]}"

