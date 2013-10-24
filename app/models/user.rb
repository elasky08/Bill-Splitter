class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :group
  has_many :user_items
  has_many :items, through: :user_items
  has_many :payments
  has_many :owned_groups, class_name: "Group", foreign_key: "owner_id"
end
