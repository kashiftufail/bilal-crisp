class AddFieldsToDiscountCodes < ActiveRecord::Migration
  def self.up
    add_column :discount_codes, :start_date, :datetime
    add_column :discount_codes, :end_date, :datetime
    add_column :discount_codes, :value, :float
  end

  def self.down
    remove_column :discount_codes, :start_date
    remove_column :discount_codes, :end_date
    remove_column :discount_codes, :value
  end
end
