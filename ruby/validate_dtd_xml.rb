require 'nokogiri'

xml = File.read ARGV.pop
options = Nokogiri::XML::ParseOptions::DTDLOAD   # Needed for the external DTD to be loaded
doc = Nokogiri::XML::Document.parse(xml, nil, nil, options)
puts doc.external_subset.validate(doc)


