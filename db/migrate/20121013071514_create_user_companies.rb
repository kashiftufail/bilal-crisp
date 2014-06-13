class CreateUserCompanies < ActiveRecord::Migration
  def self.up
    create_table :user_companies do |t|
      t.references :user
      t.references :company

      t.timestamps
    end
    add_index(:user_companies, [:user_id, :company_id], :unique => true)
  end

  def self.down
    drop_table :user_companies
  end
end
