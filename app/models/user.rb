# Primary Author: Jonathan Allen (jallen01)

class User < ActiveRecord::Base

  # Attributes
  # ----------

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships
  has_many :partitions, dependent: :destroy
  has_many :items, through: :partitions
  has_many :owned_groups, class_name: "Group", foreign_key: "owner_id", dependent: :destroy

  # Returns a unique name for the user.
  def unique_name
    self.email.gsub('@', '-').split(".")[0]
  end

  before_validation { self.email = self.email.downcase }

  # Validations
  # -----------

  NAME_MAX_LENGTH = 20
  validates :name, presence: true, length: { maximum: User::NAME_MAX_LENGTH }

  
  # Methods
  # -------

  # Returns a string represenation of the user.
  def to_s
    "#{self.name}"
  end

end
