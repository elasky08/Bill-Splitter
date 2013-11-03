class CreatePartitions < ActiveRecord::Migration
  def change
    create_table :partitions do |t|
      t.belongs_to :user
      t.belongs_to :item

      t.timestamps
    end
  end
end
