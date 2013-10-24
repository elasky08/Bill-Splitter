class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :amount
      t.belongs_to :group
      t.belongs_to :user

      t.timestamps
    end
  end
end
