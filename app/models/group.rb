class Group < ActiveRecord::Base
  has_many :users
  has_many :items
  has_many :payments 
  belongs_to :owner, class_name: "User"
end
