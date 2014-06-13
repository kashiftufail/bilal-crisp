class CreateAdminRoles < ActiveRecord::Migration
  def self.up
    create_table :admin_roles do |t|
      t.references :admin_user
      t.references :role
    end
    add_index(:admin_roles, [:admin_user_id, :role_id])
  end

  def self.down
    drop_table :admin_roles
  end
end
