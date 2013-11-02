# Primary Author: Jonathan Allen (jallen01)

class Partition < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
end
