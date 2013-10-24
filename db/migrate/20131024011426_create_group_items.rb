class CreateGroupItems < ActiveRecord::Migration
  def change
    create_table :group_items do |t|

      t.timestamps
    end
  end
end
