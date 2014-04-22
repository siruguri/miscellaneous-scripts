# This one is more recent and uses the google-drive-ruby gem.

require 'time'

require "rubygems"
require "google_drive"
require 'parseconfig'

config=ParseConfig.new('drive_secret.ini')

class CTNCalendarReader
  def initialize(ws)
    @debug=1
    @ws = ws
    @headings={center_name: 0, day_of_week: 1, time_of_day: 2, assignment_status: 3, all_slots: 4}
  end

  def process_slots(all_slots_string)
    @errors = []
    if all_slots_string.nil?
      log("No string passed for hours processing.")
      return
    end

    hours=all_slots_string.split(/\s*,\s*/)
    hours.each do |range|
      start, finish = range.split(/\s*\-\s*/)
      begin
        start_time = Time.parse start
        finish_time = Time.parse finish
      rescue ArgumentError => e
        @errors << "Ignoring unparseable times: #{start} and #{finish}"
        next
      end
        
      
      
    end
  end

  def compute_open_slots
    computed = {center_name: '', day_of_week: '', all_slots: ''}
    avlbl_slots = {}
    
    @ws.rows.each do |row|
      update_values(computed, row[@headings[:center_name]])
      update_values(computed, row[@headings[:day_of_week]])
      update_values(computed, row[@headings[:all_slots]])

      avlbl_slots[computed[:day_of_week]] = process_slots(computed[:all_slots])

      open_slots[computed[:day_of_week]] = avlbl_slots[computed[:day_of_week]]
      open_slots = remove_slot(open_slots, row[@headings[:time_of_day]])
    end
        
  end

  private

  def update_values(value_hash, new_val)
    all_whitespace = Regexp.new('^\s*$')

    if all_whitespace.match(new_val).nil?
        value_hash[sym] = new_val
    end
  end

  def log(mesg)
    if(@debug)
      $stderr.write("#{mesg}\n")
    end
  end
end

begin
  session = GoogleDrive.login("siruguri@gmail.com", config['secret_key'])
rescue AuthenticationError => ex
  puts "Auth failed: #{ex.message}"
end

# First worksheet of
# https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
ws = session.spreadsheet_by_key("1gYJz-SBtbM9rFomO1EWCFSkfVeUCTAqDG9TQ8o31j4I").worksheets[0]

puts "A2: #{ws[1, 2]}"
puts "D10: #{ws[10, 4]}"

reader = CTNCalendarReader.new(ws)
reader.compute_open_slots
