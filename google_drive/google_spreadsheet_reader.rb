# This one is more recent and uses the google-drive-ruby gem.

require 'pry'
require 'pry-debugger'

require 'time'

require "rubygems"
require "google_drive"
require 'parseconfig'

config=ParseConfig.new('drive_secret.ini')

class CTNCalendarReader
  class NoSlotsGiven < Exception
  end

  def initialize(ws)
    @debug=1
    @ws = ws
    @headings={center_name: 0, day_of_week: 1, time_of_day: 2, assignment_status: 3, all_slots: 4}
    @open_slots = {}

  end

  def compute_open_slots()
    computed = {center_name: '', day_of_week: '', all_slots: ''}
    avlbl_slots = {}
    
    @ws.rows.each do |row|
      update_values(computed, row, :center_name)

      if !blank?(row[@headings[:day_of_week]]) && computed[:day_of_week] != row[@headings[:day_of_week]] then
        log("Re-calculating slots for a new day: #{row[@headings[:day_of_week]]}")

        # Assume: when day of week changes, the all_slots column is filled.
        if blank? row[@headings[:all_slots]]
          raise CTNCalendarReader::NoSlotsGiven, "No slots were given for center #{row[@headings[:center_name]]}, day #{row[@headings[:day_of_week]]}."
        end

        update_values(computed, row, :day_of_week)
        update_values(computed, row, :all_slots)

        # Initialize open slots with all slots

        avlbl_slots[computed[:day_of_week]] = process_slots(computed[:all_slots])
        @open_slots[computed[:day_of_week]]=avlbl_slots[computed[:day_of_week]]
      end

      @open_slots[computed[:day_of_week]] = remove_slot(@open_slots[computed[:day_of_week]], row[@headings[:time_of_day]])
    end
        
  end

  private

  def process_slots(all_slots_string)
    @errors = []
    if all_slots_string.nil?
      log("No string passed for hours processing.")
      return
    end

    hours=all_slots_string.split(/\s*,\s*/)
    open_slots = []
    hours.each do |range|        
      open_slots << convert_to_times(range)
    end

    open_slots.compact
  end

  def convert_to_times(range)
    range_values = range.split(/\s*\-\s*/)

    begin
    range_values.map! do |t|
        if /[ap]$/.match t
          t=t+"m"
        end
        x=Time.parse t
        log("Converting #{t} to #{x}")
        x
      end
    rescue ArgumentError => e
      @errors << "Ignoring unparseable time(s): #{range_values}"
      return nil
    end
    {start: range_values[0], end: range_values[1]}
  end

  def blank?(string)
    Regexp.new('^\s*$').match string
  end

  def remove_slot(open_slots, taken_slot)
    return open_slots if blank? taken_slot

    log("Old open slots = #{open_slots}")
    # Remove the taken slot if it's in the list of open slots
    slot_hash = convert_to_times(taken_slot)
    x=open_slots.select do |slot|
      !(slot[:start] == slot_hash[:start] && slot[:end] == slot_hash[:end]) 
    end

    log("New open slots = #{x}")
    x
  end

  def update_values(value_hash, row, sym)
    if !(blank? row[@headings[sym]])
        value_hash[sym] = row[@headings[sym]]
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
# ws = session.spreadsheet_by_key("1gYJz-SBtbM9rFomO1EWCFSkfVeUCTAqDG9TQ8o31j4I").worksheets[0]

ws = session.spreadsheet_by_key('1nXNQlaslBJBz3GCfyaUAu8D_i-nNkAsMzqYM6yfsiTc').worksheets[0]

puts "A2: #{ws[1, 2]}"
puts "D10: #{ws[10, 4]}"

reader = CTNCalendarReader.new(ws)
reader.compute_open_slots
