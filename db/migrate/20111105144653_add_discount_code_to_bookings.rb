class AddDiscountCodeToBookings < ActiveRecord::Migration
  def self.up
    add_column :bookings, :discount_code, :string
  end

  def self.down
    remove_column :bookings, :discount_code
  end
end
