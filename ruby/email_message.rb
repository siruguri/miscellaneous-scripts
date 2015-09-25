require 'getoptlong'
require 'mailer_client.rb'

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--to_list', '-t', GetoptLong::OPTIONAL_ARGUMENT],
  [ '--subject', '-s', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--message', '-m', GetoptLong::OPTIONAL_ARGUMENT ]
)

def file_or_string input
  # if it's a file it reads the file's input and returns that, else if
  # the input is a string, it returns it

  if File.exist?(input)
    ret_val = ''
    File.open(input).each { |line| ret_val += line }
    return ret_val
  end
  
  if input.is_a?(String)
    return input
  else
    return ''
  end
end

def error_exit(msg)
  puts "Error found... exiting ..."
  puts msg
  exit -1
end
  
def print_help_and_exit
  puts <<EOS
  setup.rb [options]

  Options:
    -s, --source: Location of patches
    -d, --destination: Location of Rails app base folder (Rails.root)
EOS
  exit 0
end

to_list = "Sameer at Techsoup <ssiruguri@techsoupglobal.org>, Sameer Siruguri <sameers.public@gmail.com>"
subject = 'Dummy Subject'
message = 'Dummy Message'

opts.each do |opt, arg|
   case opt
     when '--help'
     print_help_and_exit
     
     when '--to_list'
     to_list = arg.to_s
     
     when '--subject'
     subject = arg.to_s

     when '--message'
     message = arg.to_s
   end
end

client = MailerModule::MailerClient.new(from: 'siruguri@gmail.com', to: 'siruguri@gmail.com', sender_name: "Sameer Siruguri")

if !client.nil?
  client.subject = file_or_string(subject)
  client.message = file_or_string(message)
end

file_or_string(to_list).split(/\n/).each do |line|
  line.split(/,\s+/).each do |email|
    puts "Emailing #{email}"
    client.to_string = email
    client.email
  end
end

