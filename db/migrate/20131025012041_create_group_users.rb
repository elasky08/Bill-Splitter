class CreateGroupUsers < ActiveRecord::Migration
  def change
    create_table :group_users do |t|
      t.belongs_to :group
      t.belongs_to :user
      t.decimal :amount
      
      t.timestamps
    end
  end
end
