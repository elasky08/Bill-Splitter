# Primary Author: Jonathan Allen (jallen01)

class Item < ActiveRecord::Base

  # Attributes
  # ----------

  has_many :user_items, :dependent: :destroy
  has_many :users, through: :user_items
  belongs_to :group


  # Validations
  # -----------

  NAME_MAX_LENGTH = 20
  validates :name, presence: true, length: {minimum: 1, maximum: ITEM::NAME_MAX_LENGTH}, uniqueness: { scope: :group }
  validates :cost, presence: true, currency: true

  before_validation {self.name.downcase}


  # Methods
  # -------

  # Returns a string representation of the item. 
  def to_s
    "#{self.name.downcase.split.map(&:capitalize).join(' ')}: #{number_to_currency(self.cost, :unit => "$")}"
  end

  # Returns true if item is shared with specified user.
  def include_user?(user)
    users.include? user
  end

  # Shares item with specified user. Does nothing if item is already shared with user. Returns true if successful, false otherwise.
  def add_user(user)
    if self.include_user?(user)
      return true
    end

    # Check that the user is in the item's group.
    if self.group.include_user?(user)
      return UserItem.create(user_id: user.id, group_id: group.id)
    else  
      record.errors[:users] << (options[:message] || "is not a member of the item's group")
      return false
    end
  end
end
