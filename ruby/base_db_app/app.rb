require 'rubygems'
require 'bundler/setup'
require 'getoptlong'
require 'zlib'
require 'yaml'

Bundler.require(:default)
APP_ENVIRONMENT = ENV['APP_ENVIRONMENT'] || 'development'
dbconfig = YAML::load(File.open('config/database.yml'))[APP_ENVIRONMENT]

appconfig = (File.exist?('config/app.yml') ? YAML::load(File.open('config/app.yml')) : nil)

ActiveRecord::Base.establish_connection(dbconfig)
Dir.glob(File.join('models', '**', '*rb')).each { |f| require_relative f }
Dir.glob(File.join('lib', '**', '*rb')).each { |f| require_relative f }

class App
  attr_reader :config
  attr_accessor :db_conn
  
  def config=(cfg)
    unless cfg.nil?
      @_cfg={}
      cfg.keys.each do |k|
        @_cfg[k]=cfg[k]
      end
    end
    @_cfg
  end
end

class LogAnalysisApp < App
  def apache_log_analyze(method, file)
    ApacheLogs.new.run method, file
  end
end

myapp = LogAnalysisApp.new
myapp.config = appconfig

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--database', '-d', GetoptLong::REQUIRED_ARGUMENT],
  [ '--file', '-f', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--method', '-m', GetoptLong::REQUIRED_ARGUMENT]
)

myapp.db_conn = input_file = nil
method = 'four_04s'

opts.each do |opt, arg|
  case opt
  when '--database'
    myapp.db_conn = SQLite3::Database.new arg
    
  when '--file'
    if File.exist? arg
      input_file = arg
    end
  when '--method'
    method = arg
  end
end

if !myapp.db_conn.nil? and !input_file.nil?
  begin
    ApacheLogs.new.run method, input_file, myapp
  rescue ApacheLogs::UnknownMethodException => e
    $stderr.puts("That method is not known.")
  end
else
  $stderr.write("Please enter at least two cmd line args: the method of analysis (from amongst this list - #{ApacheLogs.allowed_methods}); and the log file or a directory containing them (can be gzipped).\n")
  exit -1
end  
