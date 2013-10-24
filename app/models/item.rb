class Item < ActiveRecord::Base
  has_many :user_items
  has_many :users, through: :user_items
  belongs_to :group
end
