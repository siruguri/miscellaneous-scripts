require 'sqlite3'

class ArDatabaseConnector
  def initialize(config_filename='config/database.yml')
    @_config = YAML::load(File.open config_filename)
    ActiveRecord::Base.establish_connection(@_config)

    if @_config['debug_sql']
      begin
        ActiveRecord::Base.logger = Logger.new(File.open('log/app.log', 'a'))
      rescue Errno::ENOENT => e
        $stderr.write "Log file specified for db logging log/app.log not available for writing to (or folder is not created.)"
        exit -1
      end
    end

    def run_migrations(dirname)
      if Dir.exists? dirname
        ActiveRecord::Migrator.migrate dirname, ENV['VERSION'] ? ENV['VERSION'].to_i : nil
      end
    end
  end
end

