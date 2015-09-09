require 'sqlite3'

class DatabaseConnector
  def initialize(filename='dev.sql3')
    @_conn = SQLite3::Database.new filename
  end

  def query(q, arr)
    @_conn.execute q, arr
  end
  alias :execute :query
  
  def create_table(tbl_name, col_defs)
    @_conn.execute "create table if not exists #{tbl_name} (#{col_defs})"
  end
end

