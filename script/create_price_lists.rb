require 'csv'

klasses = ["PriceList","PriceListCategory"]

klasses.each do |k|
  klass = k.constantize
  klass.connection.execute("TRUNCATE table #{klass.table_name}")
  puts "Table #{klass.table_name} truncated."
end

 @category = nil
CSV.open("db/price_list.csv","r") do |row|
  if row.length < 2
    @category = PriceListCategory.create(:name => row.first)
    puts "Category #{@category.name} added."
  else
    PriceList.create(:item_name => row.first, :price => row.last, :price_list_category_id => @category.id )
    puts "Price for #{row.first} set as #{row.last}."
  end
end
