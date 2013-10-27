# Primary Author: Jonathan Allen (jallen01)

class Group < ActiveRecord::Base

  # Attributes
  # ----------

  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_many :items, dependent: :destroy
  belongs_to :owner, class_name: "User"

  # Returns unique group identifier name.
  def unique_name
    "#{self.owner.unique_name}-#{self.name}"
  end

  scope :ordered, -> { order :created_at }


  # Validations
  # -----------

  NAME_MAX_LENGTH = 20
  validates :name, presence: true, length: { minimum: 1, maximum: Group::NAME_MAX_LENGTH }, uniqueness: { scope: :owner }

  before_validation { self.name = self.name.downcase }

  # Make sure that owner is a group user
  def add_owner_group_user
    self.add_user(self.owner)
  end
  after_save :add_owner_group_user


  # Methods
  # -------

  # Returns a string represenation of the group.
  def to_s
    "#{self.name.split.map(&:capitalize).join(' ')}"
  end

  # Returns true if user is in the group.
  def include_user?(user)
    self.users.exists?(user)
  end 

  # Adds user to group. Does nothing if user is already in group. Returns true if successful, false otherwise.
  def add_user(user)
    return self.group_users.find_or_create_by(user: user)
  end

  def get_group_user(user)
    return self.group_users.find_by(user: user)
  end

  # Removes user from group. Does nothing if item is not already shared with user.
  def remove_user(user)
    # Cannot remove group owner.
    if user != self.owner
      self.group_users.delete(user: user)
    end
  end

  # Returns sum of all payment amounts.
  def get_payments_total
    self.group_users.to_a.sum { |group_user| group_user.payment }
  end

  # Create item with specified name, and add it to the group. Returns the item object. 
  def edit_item_by_name(name, cost)
    item = self.items.create(name: name, cost: cost)
  end

  # Returns sum of all item costs.
  def get_items_total
    self.items.to_a.sum { |item| item.cost }
  end

  # Returns the group items shared with specified user.
  def get_user_items(user)
    self.items.joins(:user_items).where(:user_items => { user: user })
  end

  # Returns partial cost of all items shared with specified user.
  def get_user_items_total(user)
    self.get_user_items(user).to_a.sum { |item| item.cost }
  end

end
