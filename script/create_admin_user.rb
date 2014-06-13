u = User.find_by_email "admin@crisp.com"
u.destroy if u
user = User.create :first_name => "Admin", :surname => "User", :email => "admin@crisp.com", :password => "admin123", :password_confirmation => "admin123", :mobile_number => "+447700000000", :home_number => "7700000000", :post_code => 'ABCD 123', :address_1 => "Admin Area"
user.roles.create :name => 'admin'

puts "USER:     admin"
puts "PASSWORD: admin123"
