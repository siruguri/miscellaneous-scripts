require 'parseconfig'
require 'rubygems'
require 'xmlsimple'
require 'pp'
require 'net/https'

def get_feed(uri, headers=nil)
  uri = URI.parse(uri)
  Net::HTTP.start(uri.host, uri.port) do |http|
    return http.get(uri.path, headers)
  end
end

begin
  config=ParseConfig.new('google_client_config.ini')
rescue Errno::EACCES => e
  $stderr.write("There needs to be a config file called google_client_config.ini (#{e.class}, #{e.message})\n")
  exit -1
end

http = Net::HTTP.new('www.google.com', 443)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

# elements of auth 
path = '/accounts/ClientLogin'
data = 'accountType=HOSTED_OR_GOOGLE&Email=#{config['client_login_email']}&Passwd=#{config['client_login_pwd']}&service=wise'
headers = {"Content-Type"=>"application/x-www-form-urlencoded"}

# Post the request and print out the response to retrieve our authentication token
resp, respdata = http.post(path, data, headers)

cl_string = resp.body[/Auth=(.*)/, 1]

# Build our headers hash and add the authorization token
headers["Authorization"] = "GoogleLogin auth=#{cl_string}"

# spreadsheets_uri = 'http://spreadsheets.google.com/feeds/spreadsheets/private/full'

docs_uri = 'http://docs.google.com/feeds/docs/private/full'
my_list = get_feed(docs_uri, headers)


doc =  XmlSimple.xml_in(my_list.body, 'KeyAttr' => 'name')
pp doc
