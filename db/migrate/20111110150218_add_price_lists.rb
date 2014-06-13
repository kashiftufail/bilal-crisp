class AddPriceLists < ActiveRecord::Migration
require 'csv'
  def self.up

    @category = nil
  CSV.foreach("db/price_list.csv") do |row|
    if row.count < 2
      @category = PriceListCategory.create(:name => row.first)
      puts "Category #{@category} added."
    else
      PriceList.create(:item_name => row.first, :price => row.last, :price_list_category_id => @category.id )
      puts "Price for #{row.first} set as #{row.last}."
    end
  end
  end

  def self.down
      klasses = ["PriceList","PriceListCategory"]

      klasses.each do |k|
        klass = k.constantize
        klass.connection.execute("TRUNCATE table #{klass.table_name}")
        puts "Table #{klass.table_name} truncated."
      end
  end
end
