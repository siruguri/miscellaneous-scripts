require 'parseconfig'
require 'rubygems'
require 'xmlsimple'
require 'pp'
require "rexml/document"
require 'net/https'

include REXML

def atom_xml(elt_array) 

  str = ''
  elt_array.each do |elt|
    str += "<#{elt[0]} "

    if elt[1][:attr]
      elt[1][:attr].each do |attr_key, attr_value|
        str += "#{attr_key}='#{attr_value}' "
      end
    end
    str += " > "

    if elt[1][:children]
      str += atom_xml(elt[1][:children])
    end

    # Not checking that a tag has both children and value, which is not allowed.
    if elt[1][:value]
      str += " #{elt[1][:value]} "
    end

    # Returning str
    str += " </#{elt[0]}> "
  end

  str
end

def generate_atom(options)
  entry_elements = 
    [["atom:entry", {attr: {"xmlns:atom" => 'http://www.w3.org/2005/Atom', "xmlns:gd" => 'http://schemas.google.com/g/2005'}, children: [
                                                                                                                                        ["atom:category", {attr: {'scheme' => 'http://schemas.google.com/g/2005#kind', 'term' => 'http://schemas.google.com/contact/2008#contact'}}],
     ["gd:name", {children:  [["gd:fullName", {value: 'Darcy McFarcy'}], 
                                ["gd:familyName", {value: 'McFarcy'}]]}],
     ['atom:content', {attr: {'type' => 'text'}, value: 'Notes'}],
     ['gd:email', {attr: {'rel' => 'http://schemas.google.com/g/2005#work', 'primary' => 'true', 'address'=>'darcyfarcy@gmail.com', 'displayName' => 'D. Farcy Esq.'}}]
    ]}
                   ]]

  atom_xml(entry_elements)
end

def get_feed(uri, headers=nil)
  uri = URI.parse(uri)
  Net::HTTP.start(uri.host, uri.port) do |http|
    http.get(uri.path, headers)
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
data = "accountType=#{config['client_login_account_type']}&Email=#{config['client_login_email']}&Passwd=#{config['client_login_pwd']}&service=#{config['client_login_service_name']}&source=CCLR_dev_test"
headers = {"Content-Type"=>"application/x-www-form-urlencoded"}

# Post the request and print out the response to retrieve our authentication token
resp = http.post(path, data, headers)
if resp.code == '200' then
  cl_string = resp.body[/Auth=(.*)/, 1]

  # Build our headers hash and add the authorization token
  headers["Authorization"] = "GoogleLogin auth=#{cl_string}"

  # spreadsheets_uri = 'http://spreadsheets.google.com/feeds/spreadsheets/private/full'
  # This is deprecated now - docs_uri = 'http://docs.google.com/feeds/docs/private/full'; uri = docs_uri

  contacts_path = '/m8/feeds/contacts/cclr.org/full';  path = contacts_path

  # my_list = get_feed(uri, headers)
  resp = http.get(path, headers)
  #  doc =  XmlSimple.xml_in(my_list.body)
  pp resp.body

  puts "Creating new contact..."
  new_entry_xml = generate_atom(1)
  headers['Content-Type']='application/atom+xml'
#  resp=http.post(path, new_entry_xml, headers);  pp resp.body
else 
  puts "Response status was #{resp.code}"
end
