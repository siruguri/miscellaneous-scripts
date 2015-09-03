require_relative "./database_connector.rb"
require 'pry'

conn = DatabaseConnector.new('tester.sqlite')
conn.execute('create table if not exists posts (name string, post_date datetime)')

t = Date.today
conn.execute("insert into posts values ('post 1', #{t})")
conn.execute("select count(*) from posts")

