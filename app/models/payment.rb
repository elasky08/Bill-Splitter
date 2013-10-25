# Primary Author: Jonathan Allen (jallen01)
class Payment < ActiveRecord::Base

  # Attributes
  # ----------

  belongs_to :user
  belongs_to :group


  # Validations
  # -----------

  validates :cost, presence: true, currency: true
end
