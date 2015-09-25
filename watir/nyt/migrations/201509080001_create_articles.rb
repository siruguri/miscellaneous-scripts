class CreateArticles < ActiveRecord::Migration
#db_c.create_table 'articles', 'id integer primary key, title text, body text, crawled_date datetime'
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.datetime :crawled_date
      t.timestamps
    end
  end
end
