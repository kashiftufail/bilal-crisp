class AddFieldsToBookings < ActiveRecord::Migration
  def self.up
    add_column :bookings, :items_count, :integer
    add_column :bookings, :status, :string, :default => "Pending"
    add_column :bookings, :cost, :float
  end

  def self.down
    remove_column :bookings, :items_count
    remove_column :bookings, :status
    remove_column :bookings, :cost
  end
end
