require 'net/smtp'

module MailerModule
  class MailerClient
    @sender_name = "Sameer Siruguri"
    @subject = "Hello World!"
    @message = "Hello World!"
    @to_string = ""

    attr_accessor :message, :subject, :to_string

    def initialize(options={})
      if options.has_key? :to
        @to_string = options[:to]
      else
        # To address option needs to be specified.
        return nil
      end

      if options.has_key? :from
        @from_string = options[:from]
      else
        # From address option needs to be specified.
        return nil
      end

      @sender_name = options[:sender_name] || @sender_name
      @subject = options[:subject] || @subject
      @message = options[:message] || options[:body] || @message
    end


    def email()
      begin
        to_list = @to_string.split /;\s*/
        to_list = to_list.map { |x| y=(/^[^>]+\s*<(.*)>/.match(x)); if y.nil? then x else y[1] end}
        puts to_list

        smtp = make_smtp_client()
        to_list.each do |to|
          begin
            mesg = make_message_header_and_body(to)
            smtp.start('smtp.gmail.com', 'siruguri', ENV['gmail_app_password'], :login) do |smtp|
              smtp.send_message(mesg, 'siruguri@gmail.com', to)
            end
          rescue Exception => e
            puts "Error for #{to}: #{e.message}"
          end
        end

      end
    end

    private
    def make_smtp_client
      smtp=Net::SMTP.new('smtp.gmail.com', 587)
      smtp.enable_starttls
      smtp
    end

    def make_message_header_and_body(to)
      message = <<END
From: #{@sender_name} <#{@from_string}>
To: #{to} <#{to}>
MIME-Version: 1.0
Content-type: text/html
Subject: #{@subject}

#{@message}
END
    end

  end

end

