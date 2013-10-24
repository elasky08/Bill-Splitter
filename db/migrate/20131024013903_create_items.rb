class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :cost
      t.string :name
      t.belongs_to :group

      t.timestamps
    end
  end
end
