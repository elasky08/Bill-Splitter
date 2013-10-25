# Primary Author: Jonathan Allen (jallen01)

class Group < ActiveRecord::Base

  # Attributes
  # ----------

  has_many :group_users, dependent: :destroy
  has_many :users, throug: :group_users
  has_many :items, dependent: :destroy
  belongs_to :owner, class_name: "User"

  # Returns list of group users and group owner
  def all_users
    [users, owner].flatten(1)
  end

  scope :ordered, -> { order :created_at }


  # Validations
  # -----------

  NAME_MAX_LENGTH = 20
  validates :name, presence: true, length: { minimum: 1, maximum: Group::NAME_MAX_LENGTH }, uniqueness: { scope: :owner }

  before_validation { self.name.downcase }


  # Methods
  # -------

  # Returns a string represenation of the group.
  def to_s
    "#{name.split.map(&:capitalize).join(' ')}"
  end

  # Returns sum of all payment amounts.
  def get_payments_total
    group_users.sum { |group_user| group_user.payment }
  end

  # Changes user payment to specified amount. Returns true if success, false otherwise.
  def update_payment(user, amount)
    if group_users.find(user: user)
      return group_users.find(user: user).update_attributes(payment: amount)
    else
      return false
    end
  end

  # Returns sum of all item costs.
  def get_items_total
    items.sum { |item| item.cost }
  end

  def get_user_items_total(user)
    items.where(user: user).sum { |item| item.cost }
  end

  # Returns true if user is in the group.
  def include_user?(user)
    all_users.exists?(user)
  end 

  # Create item with specified name, and add it to the group. Returns the item object. If item with same name already exists in the group, returns the existing item.
  def add_item_by_name?(item_name)
    return items.find_or_create_by(name: item_name)
  end

  # Adds user to group. Does nothing if user is already in group. Returns true if successful, false otherwise.
  def add_user(user)
    return group_users.find_or_create_by(user: user)
  end

  # Removes user from group. Does nothing if item is not already shared with user.
  def remove_user(user)
    group_users.delete(user: user)
  end

end
