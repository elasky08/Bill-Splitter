# Primary Author: Jonathan Allen (jallen01)

class GroupUser < ActiveRecord::Base

  # Attributes
  # ----------

  belongs_to :group
  belongs_to :user


  # Validations
  # -----------

  validates :cost, presence: true, currency: true

  before_validation {amount}
end
