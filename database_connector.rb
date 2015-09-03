require 'sqlite3'

class DatabaseConnector
  def initialize(filename='dev.sql3')
    @_conn = SQLite3::Database.new filename
  end

  def query(q)
    @_conn.execute q
  end
  alias :execute :query
  
  def create_table(tbl_name, col_defs)
    @_conn.execute "create table if not exists #{tbl_name} (#{col_defs})"
  end
end

