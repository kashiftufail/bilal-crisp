class CreateBookings < ActiveRecord::Migration
  def self.up
    create_table :bookings do |t|
      t.date :pickup_date
      t.datetime :pickup_time
      t.date :delivery_date
      t.float :surcharge, :default => 0
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :bookings
  end
end
