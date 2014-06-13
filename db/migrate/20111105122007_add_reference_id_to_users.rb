class AddReferenceIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :ref_id, :string
  end

  def self.down
    remove_column :users, :ref_id
  end
end
