class CreateBills < ActiveRecord::Migration
  def self.up
    create_table :bills do |t|
      t.string :amount
      t.integer :source_id
      t.datetime :created_at_time
      t.integer :bill_id
      t.integer :pre_user_id
      t.string :uri
      t.references :pre_authorization
      t.integer :booking_id

      t.timestamps
    end
    add_index(:bills, :bill_id)
    add_index(:bills, :pre_authorization_id)
    add_index(:bills, :booking_id)
  end

  def self.down
    drop_table :bills
  end
end
