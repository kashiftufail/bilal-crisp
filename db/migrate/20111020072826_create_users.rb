class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string   :title
      t.string   :first_name
      t.string   :surname
      t.string   :city
      t.string   :post_code
      t.string   :home_number
      t.string   :mobile_number
      t.string   :login,                     :limit => 40
      t.string   :name,                      :limit => 100, :default => '', :null => true
      t.string   :email,                     :limit => 100
      t.string   :crypted_password,          :limit => 40
      t.string   :salt,                      :limit => 40
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :remember_token,            :limit => 40
      t.text     :address
      t.datetime :remember_token_expires_at


    end
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table "users"
  end
end
