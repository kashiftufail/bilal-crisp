class ChangeCompaniesTable < ActiveRecord::Migration
  def self.up
    change_column :companies, :postal_code, :string, :limit => 10
  end

  def self.down
    change_column :companies, :postal_code, :string, :limit => 6
  end
end
