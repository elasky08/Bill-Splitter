class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.decimal :cost, precision: 8, scale: 2, null: false
      t.boolean :all_users
      t.string :name, null: false
      t.belongs_to :group

      t.timestamps
    end
  end
end
