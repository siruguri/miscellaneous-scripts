require 'my_utilities'
require "selenium-webdriver"

opt_map = { query_base: "q:query-base" }

opts_array = MyUtilities::process_cli opt_map
# opts_array => {query_base: <value of -q or --query-base option, if specified> }

driver = Selenium::WebDriver.for :firefox
states = File.open(ARGV[0]).readlines

states.each do |state|
  state = state.chomp

  q="why is #{state} so "
  $stderr.puts q

  driver.navigate.to "http://www.google.com/"
  # Enter the search query
  inp = driver.find_element(:name, 'q')

  inp.send_keys q

  # Necessary for JS to run to get the autocomplete data
  sleep 5

  # get the list of auto completes
  ins = driver.find_elements css:'table.gssb_m'

  # Get the completions from inside the list
  coms = ins[0].find_elements css: 'td.gssb_a'

  # All the completions are in bold, if we are only interested in suffixes
  ends = coms.map do |x| 
    begin
      x.find_element css: 'b'
    rescue Selenium::WebDriver::Error::NoSuchElementError => e
      nil
    end
  end

  ends.each do |suffix|
    puts "#{q}#{suffix.text}" unless suffix.nil?
  end
end

driver.quit


