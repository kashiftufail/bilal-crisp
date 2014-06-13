class CreatePriceLists < ActiveRecord::Migration
  def self.up
    create_table :price_lists do |t|
      t.string :item_name
      t.float :price
      t.integer :price_list_category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :price_lists
  end
end
