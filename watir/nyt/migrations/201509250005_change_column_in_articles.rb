class ChangeColumnInArticles < ActiveRecord::Migration
  def change
    rename_column :articles, :crawled_date, :pub_date
  end
end
