class CreateDiscountCodes < ActiveRecord::Migration
  def self.up
    create_table :discount_codes do |t|

      t.string :discount_code
      t.string :code_type
      t.string   :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :discount_codes
  end
end

