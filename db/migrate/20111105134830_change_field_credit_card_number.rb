class ChangeFieldCreditCardNumber < ActiveRecord::Migration
  def self.up
    remove_column :payment_details, :credit_card_number
    add_column :payment_details, :credit_card_number, :string
  end

  def self.down
    add_column :payment_details, :credit_card_number, :integer
    remove_column :payment_details, :credit_card_number
  end
end
