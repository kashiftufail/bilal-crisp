class AddSpecialInstructionsToBookings < ActiveRecord::Migration
  def self.up
    add_column :bookings, :special_instructions, :text
  end

  def self.down
    remove_column :bookings, :special_instructions
  end
end
