class CreatePreAuthorizations < ActiveRecord::Migration
  def self.up
    create_table :pre_authorizations do |t|

      t.integer :pre_id
      t.integer :interval_length
      t.string :interval_unit
      t.integer :user_id
      t.integer :go_user_id
      t.string :max_amount
      t.string :uri
      t.datetime :created_at_time
      t.timestamps
    end
    add_index(:pre_authorizations, :pre_id)
    add_index(:pre_authorizations, :user_id)
  end

  def self.down
    drop_table :pre_authorizations
  end
end
