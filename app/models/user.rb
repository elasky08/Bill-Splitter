# Primary Author: Jonathan Allen (jallen01)

class User < ActiveRecord::Base
  # Use username as id.
  extend FriendlyId
  friendly_id :name, use: [:slugged]

  # Attributes
  # ----------

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :user_items, dependent: :destroy
  has_many :items, through: :user_items
  has_many :owned_groups, class_name: "Group", foreign_key: "owner_id", dependent: :destroy

  # Returns list of groups owned by user and groups to which user belongs.
  def all_groups
    [groups, owned_groups].flatten(1)
  end

  # Returns a unique name for the user.
  def unique_name
    email.gsub('@', '-').split(".")[0]
  end


  # Validations
  # -----------

  NAME_MAX_LENGTH = 20
  validates :name, presence: true, length: { minimum: 1, maximum: User::NAME_MAX_LENGTH }

  
  # Methods
  # -------

  # Returns a string represenation of the user.
  def to_s
    "#{self.name}"
  end

end
