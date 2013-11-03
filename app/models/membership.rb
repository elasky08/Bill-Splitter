# Primary Author: Jonathan Allen (jallen01)

class Membership < ActiveRecord::Base


  # Attributes
  # ----------

  belongs_to :group
  belongs_to :user


  # Validations
  # -----------

  validates :payment, presence: true, numericality: true

  # If no payment, set to 0.
  before_validation { self.payment ||= 0 }

  # Remove group partitions associated with user
  before_destroy { self.group.items.each { |item| item.partitions.where(user: self.user).destroy_all } }

  # Resave all group items to include new user on group expenses.
  after_create { self.group.items.each { |item| item.save } }
end
