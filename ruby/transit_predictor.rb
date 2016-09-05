require 'net/http'

resp = Net::HTTP.get URI('https://proxy-prod.511.org/api-proxy/api/v1/transit/stop/?stopcode=54700')
puts resp
