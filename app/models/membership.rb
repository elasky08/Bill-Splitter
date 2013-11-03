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
  def remove_partitions
    Partition.joins(:items).where(user: self.user, items: { group_id: self.group.id }).destroy_all
  end
  before_destroy :remove_partitions
end
