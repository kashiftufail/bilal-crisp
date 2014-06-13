class CreateUserPlans < ActiveRecord::Migration
  def self.up
    create_table :user_plans do |t|
      t.references :user
      t.references :plan
    end
    add_index(:user_plans, [:user_id, :plan_id], :unique => true)
  end

  def self.down
    drop_table :user_plans
  end
end
