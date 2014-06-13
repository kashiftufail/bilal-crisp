class CreatePasswordCodes < ActiveRecord::Migration
  def self.up
    create_table :password_codes do |t|
      t.string   :code
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :password_codes
  end
end
