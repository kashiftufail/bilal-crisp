class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.integer :user_id, :null => false
      t.string  :name,    :null => false

      t.timestamps
    end

    add_index :roles, :user_id
  end

  def self.down
    drop_table :roles
  end
end
