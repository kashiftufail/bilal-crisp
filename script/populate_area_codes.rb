require 'csv'

  AreaCode.connection.execute("TRUNCATE table area_codes")

CSV.open("db/area_codes.csv","r") do |row|
    AreaCode.create(:area_code => row.first, :area_name => row.last )
    puts "Area Code for #{row.last} set as #{row.first}."
end
