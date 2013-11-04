# Primary Author: Jonathan Allen (jallen01)

class Membership < ActiveRecord::Base


  # Attributes
  # ----------

  belongs_to :group
  belongs_to :user

  has_many :debtors, class_name: "Membership", foreign_key: "creditor_id"
  belongs_to :creditor, class_name: "Membership"

  # Remove group partitions associated with user
  before_destroy { self.group.items.each { |item| item.get_partition(user).destroy_all } }

  # Resave all group items to include new user on group expenses.
  after_create { self.group.items.each { |item| item.save } }

  def debtor_users
    self.debtors.to_a.map(&:user)
  end
end
