class User < ActiveRecord::Base

  # Attributes
  # ----------

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :group
  has_many :user_items
  has_many :items, through: :user_items
  has_many :payments, dependent: :destroy
  has_many :owned_groups, class_name: "Group", foreign_key: "owner_id", dependent: :destroy


  # Validations
  # -----------

  NAME_MAX_LENGTH = 20
  validates :name, presence: true, length: {minimum: 1, maximum: Group::NAME_MAX_LENGTH}, uniqueness: { scope: :owner }
end
