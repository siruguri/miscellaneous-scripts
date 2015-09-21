class MailerClass
  class MailerException < Exception
  end
  
  def initialize(username: nil , password: nil)
    if username.nil? or password.nil?
      raise MailerException, "Must supply both gmail username and password to mailer"
    end
    @body = ''
    
    @options={ :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => 'gmail.com',
      :user_name             => username,
      :password             => password,
      :authentication       => 'plain',
      :enable_starttls_auto => true  }

    # This is necessary due to very terrible behavior in the mail gem :(
    # A pull request for which is available but not merged
    # https://github.com/mikel/mail/pull/900
    
    options = @options
    Mail.defaults do
      delivery_method :smtp, options
    end
  end

  def sendmail_smtp(opts_h)
    opts = opts_h
    if opts[:to].nil?
      raise MailerException, "Cannot send mail with a to: option"
    end

    # This is necessary due to very terrible behavior in the mail gem :(
    # A pull request for which is available but not merged
    # https://github.com/mikel/mail/pull/900
    
    correctly_bound_value = @options[:user_name]
    filled_in_body = @body
    mail = Mail.new do
      to  opts[:to]
      from "Auto Script Sender <#{correctly_bound_value}>"
      subject opts[:subject]
      body (opts[:body] || filled_in_body)
      if opts[:file]
        add_file opts[:file]
      end
    end

    ffrom = "Auto Script Sender <#{correctly_bound_value}>"
    fbody=@body
    mail=Mail.new do
      from ffrom; to opts[:to]
      subject opts[:subject]
      html_part do
        content_type 'text/html; charset=UTF-8'
        body fbody
      end

      text_part do
        body fbody
      end
    end
    begin
      # Ignore all exceptions.
      mail.deliver
    rescue Exception => e
      raise e
    end
    
    @body = ''
  end
  
  def add_line(str)
    #    @body += Time.now.strftime("%Y-%m-%d: %H:%M") + str
    @body += str
  end
end
