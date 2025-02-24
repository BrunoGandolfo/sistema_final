class DropUsersTable < ActiveRecord::Migration[6.1]
  def up
    drop_table :users, if_exists: true
  end

  def down
    create_table :users do |t|
      t.string :name
      t.string :email
      t.timestamps
    end
  end
end
