class AddFieldsToCompanies < ActiveRecord::Migration
  def self.up
    add_column :companies, :address, :string
    add_column :companies, :city, :string
    add_column :companies, :postal_code, :string, :limit => 6
  end

  def self.down
    remove_column :companies, :postal_code
    remove_column :companies, :city
    remove_column :companies, :address
  end
end
