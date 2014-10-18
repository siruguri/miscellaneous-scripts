require 'parse_resource'
require 'yaml'
require 'pp'

config = YAML::load(File.open('config/parse_resource.yml'))
ParseResource::Base.load!(config['app_id'], config['master_key'])

class URLInfo <  ParseResource::Base
  fields :uri
end

#puts URLInfo.where(uri: 'http://blog.techimpact.org/5-key-social-media-analytics-nonprofit-needs-track/?utm_content=buffer3e2bd&utm_medium=social&utm_source=twitter.com&utm_campaign=buffer').count

pp URLInfo.where(objectId: 'm2JsYTtj8q').first
