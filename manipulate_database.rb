require "sqlite3"
# Makes it easy to do stuff on a sqlite database
# Executes method in cmd line 1 on db in file named cmd line 0

class SQLiteOrm
  def open_db(filename)
# Open a database
    @db_conn = SQLite3::Database.new filename
    @db_conn.results_as_hash=true
  end

  def execute_method(name)
    if self.respond_to? name
      puts ">>> Executing #{name}"
      self.send name
    else
      nil
    end
  end
  
  def ratio_target_urls 
    total=count_target_urls 
    crawled=count_crawled_url
    "#{crawled/total.to_f*100}% of #{total.to_f} URLs"
  end

  def count_target_urls
    run_sql('select * from target_urls').size
  end
  def count_crawled_url
    run_sql('select * from target_urls where number_of_crawls>0').size
  end

  def check_dups
    stmt_string1 = "select distinct url from target_urls where url like '%?b=%'"
    stmt = SQLite3::Statement.new(@db_conn, stmt_string1);
    all_pg_urls = stmt.execute!
    stmt.close

    stmt_string1 = "select url from target_urls where url like '%?b=%' and number_of_crawls>0"
    stmt = SQLite3::Statement.new(@db_conn, stmt_string1);
    crawled_pg_urls = stmt.execute!

    stmt.close

    no_crawls = all_pg_urls.select do |url|

      if !(crawled_pg_urls.include? url)
        results=run_sql('select * from target_urls where url = ?', url)
        if results.size>1
          puts "#{url} needs correction"
        end
        true
      end
    end

    deleted_count = 0
    (all_pg_urls - no_crawls).each do |url|
      puts url
      results = run_sql 'delete from target_urls where url = ?', url

      deleted_count += results.size
    end

    deleted_count
  end

  def count_b0s
    cmd = 'select count(*) from target_urls where url like "%?b=0"'
    puts run_sql(cmd)
  end
  
  def delete_payloads
    cmd = 'delete from url_payloads '
    run_sql cmd
    cmd = 'vacuum'
    run_sql cmd
  end

  def 
  def update_urls
    stmt_string1 = "select * from target_urls where url like '%b=%'"
    stmt = SQLite3::Statement.new(@db_conn, stmt_string1);

    stmt.execute do |set|
      set.each do |row|
        if /\?b=\d+[^\d]/.match row['url']
          puts row['url']
          new_url = row['url'].gsub(/(\?b=\d+)[^\d].+$/, '\1')
          stmt_string = 'update target_urls set url=? where url=?'
          stmt1=SQLite3::Statement.new(@db_conn, stmt_string)
          stmt1.bind_params new_url, row['url']

          puts "changing to #{new_url}"
          stmt1.execute
          stmt1.close
        end
      end
    end
    stmt.close
    'updated'
    
  end

  private
  def run_sql(ins, *binds)
    stmt=@db_conn.prepare(ins)
    stmt.bind_params binds
    results=stmt.execute!
    stmt.close
    results
  end
end

orm = SQLiteOrm.new

if !(ARGV && ARGV.size >= 1)
  exit -1
end

if (File.exists?(ARGV[0]))
  orm.open_db ARGV[0]
else
  exit -1
end
  
puts orm.execute_method ARGV[1]


