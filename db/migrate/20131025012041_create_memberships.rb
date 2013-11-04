class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.belongs_to :group
      t.belongs_to :user
      t.integer :creditor_id, 
      
      t.timestamps
    end
  end
end
