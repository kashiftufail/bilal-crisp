class AddCorporateToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :corporate, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :users, :corporate
  end
end
