require '../code/ruby/mailer_client.rb'

client = MailerModule::MailerClient.new(from: 'siruguri@gmail.com', to: 'siruguri@gmail.com; ssiruguri@techsoupglobal.org', sender_name: "Sameer Siruguri")

email_list = "Grant Kinney <gmkcreative@gmail.com>, Elen Awalom <elenawalom@gmail.com>, john hattori <johnmhattori@yahoo.com>, Tracy <changtc@yahoo.com>, Louis <lmmedina90@gmail.com>, Cole <coleww@gmail.com>, Gabe Kopley <gabe@railsschool.org>, Dave <dorkrawk@gmail.com>, Sandy Diao <sandydiao@gmail.com>, Dilys <optanovo@gmail.com>, Daniel Uribe <duribe8@gmail.com>, Stephen Schur <promethods@gmail.com>, elnaqah <ahmed@elnaqah.com>, Kisha M Richardson <kisha@spunklabs.com>, Michael M <michael@railsschool.org>, Tracy J <tstalts@mailcan.com>, Sameer Siruguri <sameers.public@gmail.com>, Brad Johnson <brad@evolve-ca.org>"

#email_list = "Gabe Kopley <ssiruguri@techsoupglobal.org>, Sameer Siruguri <sameers.public@gmail.com>"

if !client.nil?
  client.subject = "RailsSchool Catchup: Slides and code online; Level 2 class on Jul 16!"

  client.message = 'Hi,<br><br>You are receiving this email because you had signed up for <a href="http://www.railsschool.org/l/ruby-level-2-blocks-exceptions-and-writing-a-webpage-scraper">the Ruby Catchup Level 2 class on Jul 16</a> at Rails School SF. If you were in the class, thanks for participating, and for being a lively and engaged student; your feedback will improve the class for the next batch. If you weren\'t - hello there, this is the class instructor mailing you links to the material we discussed. <p/>The code I used during the class is <a href="https://github.com/siruguri/railsschool-catchup-ruby">available on Github </a> (if you don\'t know about using Git and Github, you should look into how it works!) or you can download it as <a href="http://sameer.siruguri.net/railsschool/">a TAR.GZ or a ZIP file</a>. <p/>The lesson slides (Lessons 0 through 6) are on <a href="https://drive.google.com/?usp=folder#folders/0B4fq7EmVPd1WalQ5SFZBbnlCS0k">Google Docs</a>!<p>For upcoming Ruby catchup classes, we have an exciting series coming up - a re-do of Levels 1 and 2, and a new Level 3 class:
<ol>
<li><a href="http://www.railsschool.org/l/catch-up-day-ruby-beginners-class-level-1-aug-13">Level 1 - Data Types, Basic Conventions and Why Everything is an Object in Ruby</a>: <b>Aug 13</b></li>
<li><a href="http://www.railsschool.org/l/ruby-level-2-blocks-exceptions-and-writing-a-webpage-scraper-aug-27">Level 2 - Blocks, Exceptions, and A Simple Webpage Scraper</a>: <b>Aug 27</b></li>
<li>Level 3 - More Object Oriented Concepts, Proc-and-Block, and Advanced Conventions</a>: <b>Sep 10</b> (link coming soon!)</li>
</ol>


<p/>Cheers,<br/><br/>Sameer.<br/>
<a href="http://www.twitter.com/siruguri">@siruguri</a> - <a href="http://sameer.siruguri.net/blog">blog</a>
<p/>
'
end


email_list.split(/,\s+/).each do |email|
  puts "Emailing #{email}"
  client.to_string = email
  client.email
end
