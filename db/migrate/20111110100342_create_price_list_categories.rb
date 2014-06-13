class CreatePriceListCategories < ActiveRecord::Migration
  def self.up
    create_table :price_list_categories do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :price_list_categories
  end
end
