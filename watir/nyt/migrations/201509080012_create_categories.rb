class CreateCategories < ActiveRecord::Migration
#db_c.create_table 'categories', 'id integer primary key, article_id integer, name string'
  def change
    create_table :categories do |t|
      t.string :category_name

      t.timestamps
    end
  end
end
