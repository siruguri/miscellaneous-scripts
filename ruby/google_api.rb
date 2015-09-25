require 'byebug'
require 'google/api_client'
require 'google/api_client/client_secrets'

# Initialize the client.
client = Google::APIClient.new(
  :application_name => 'Example Ruby application',
  :application_version => '1.0.0'
)

# Initialize Google+ API. Note this will make a request to the
# discovery service every time, so be sure to use serialization
# in your production code. Check the samples for more details.

plus = client.discovered_api('admin', 'directory_v1')
byebug
puts "hello"
