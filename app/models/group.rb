# Primary Author: Jonathan Allen (jallen01)

class Group < ActiveRecord::Base

  # Attributes
  # ----------

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
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
  validates :name, presence: true, length: { maximum: Group::NAME_MAX_LENGTH }, uniqueness: { scope: :owner }

  # Capitalize first letter of each word in name
  before_validation { self.name = self.name.downcase.split.map(&:capitalize).join(' ') }

  # Make sure that owner is a group user
  def add_owner_membership
    self.add_user(self.owner)
  end
  after_save :add_owner_membership


  # Methods
  # -------

  # Returns a string represenation of the group.
  def to_s
    "#{self.name}"
  end

  # Returns true if user is in the group.
  def includes_user?(user)
    self.users.exists?(user)
  end 

  # Adds user to group. Does nothing if user is already in group. Returns true if successful, false otherwise.
  def add_user(user)
    return self.memberships.find_or_create_by(user: user)
  end

  def get_membership(user)
    return self.memberships.find_by(user: user)
  end

  # Removes user from group. Does nothing if item is not already shared with user.
  def remove_user(user)
    # Cannot remove group owner.
    if user != self.owner
      self.memberships.delete(user: user)
    end
  end


  # Returns sum of all payment amounts.
  def get_payments_total
    self.memberships.to_a.sum { |membership| membership.payment }
  end

  # Returns the group items shared with specified user.
  def get_user_items(user)
    self.items.joins(:partitions).where(:partitions => { user: user })
  end

  # Returns partial cost of all items shared with specified user.
  def get_user_total(user)
    self.get_partitions(user).to_a.sum { |item| item.cost }
  end


  # Create item with specified name, and add it to the group. Returns the item object. 
  def edit_item_by_name(name, cost)
    self.items.create_with(cost: cost).find_or_create_by(name: name)
  end

  # Returns sum of all item costs.
  def get_items_total
    self.items.to_a.sum { |item| item.cost }
  end  

end
