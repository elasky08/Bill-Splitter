class CreateGroupUsers < ActiveRecord::Migration
  def change
    create_table :group_users do |t|

      t.timestamps
    end
  end
end
