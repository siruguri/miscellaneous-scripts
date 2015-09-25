require File.join(ENV['HOME'], "code/scripts/mailer_client.rb")
require 'getoptlong'
require File.join(ENV['HOME'], "code/ruby/common_utils.rb")

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--subject', '-s', GetoptLong::REQUIRED_ARGUMENT],
  [ '--message', '-m', GetoptLong::REQUIRED_ARGUMENT],
  [ '--mails', '-l', GetoptLong::REQUIRED_ARGUMENT ]
)

client = MailerModule::MailerClient.new(from: 'siruguri@gmail.com', to: 'siruguri@gmail.com; ssiruguri@techsoupglobal.org', sender_name: "Sameer Siruguri")
if client.nil?
  error_exit("Failed to create mailer client - don't know why.")
end

email_list = ["Sameer S <kettlecheap@yahoo.com>", "Sameer Siruguri <sameers.public@gmail.com>"]

email_list_file = nil
client_subj = nil
client_message = nil

url = ''

opts.each do |opt, arg|
  if opt == '--help'
    CommonUtils.print_help_and_exit
  elsif opt == '--mails'
    email_list_file = arg.to_s
    if !File.file? email_list_file then CommonUtils.error_exit("Filename supplied for emails #{email_list_file} is not a file.")
    end
  elsif opt == '--subject'
     client_subj = arg.to_s
  elsif opt == '--message'
    puts "checking message opt"
    msg_file = arg.to_s
    if File.file?(msg_file)
      puts "Opening file #{msg_file}"
      client_message = File.open(arg.to_s).readlines.join("\n")
    else
      client_message = arg.to_s
    end
  end
end

error_exit("Either message or subject not specified") if(client_message.nil? or client_subj.nil?)

client.subject = client_subj
client.message = client_message
email_list=File.open(email_list_file).readlines unless email_list_file.nil?

email_list.each do |email|
  email = email.chomp
  puts "Emailing <<#{email}>>"
  client.to_string = email
  client.email
end
