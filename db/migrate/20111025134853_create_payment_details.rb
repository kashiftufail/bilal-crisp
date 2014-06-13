class CreatePaymentDetails < ActiveRecord::Migration
  def self.up
    create_table :payment_details do |t|
      t.string :card_type
      t.date :issue_date
      t.string :card_holder_name
      t.integer :credit_card_number
      t.date :expiration_date
      t.string :security_code
      t.text :special_instructions
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :payment_details
  end
end
