require 'open-uri'
require 'yaml'

require 'rubygems'
require 'bundler/setup'

require 'byebug'
require 'pry-byebug'

Bundler.require(:default)

dbconfig = YAML::load(File.open('config/database.yml'))
appconfig = YAML::load(File.open('config/app.yml'))

ActiveRecord::Base.establish_connection(dbconfig)
ActiveRecord::Base.logger = Logger.new(File.open('log/app.log', 'a'))

Dir.glob(File.join('lib/models', '**', '*rb')).each { |f| require_relative f }
Dir.glob(File.join('lib/app', '**', '*rb')).each { |f| require_relative f }
Dir.glob(File.join('lib/parsers', '**', '*rb')).each { |f| require_relative f }
# binding.pry

AppRunner.new(appconfig).run
