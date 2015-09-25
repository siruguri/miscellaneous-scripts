class Category < ActiveRecord::Base
  has_many :articles, through: :categorizations
  has_many :categorizations
end


