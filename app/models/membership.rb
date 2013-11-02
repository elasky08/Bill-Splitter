# Primary Author: Jonathan Allen (jallen01)

class Membership < ActiveRecord::Base


  # Attributes
  # ----------

  belongs_to :group
  belongs_to :user


  # Validations
  # -----------

  validates :payment, presence: true, currency: true

  # If no payment, set to 0.
  before_validation { self.payment ||= 0 }
end
