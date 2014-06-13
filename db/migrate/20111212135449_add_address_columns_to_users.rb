class AddAddressColumnsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :address_first, :string
    add_column :users, :address_last, :string
  end

  def self.down
    remove_column :users, :address_first
    remove_column :users, :address_last
  end
end
