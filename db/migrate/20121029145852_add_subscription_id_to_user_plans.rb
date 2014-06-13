class AddSubscriptionIdToUserPlans < ActiveRecord::Migration
  def self.up
    add_column :user_plans, :subscription_id, :string
    add_index :user_plans, :subscription_id
  end

  def self.down
    remove_index :user_plans, :subscription_id
    remove_column :user_plans, :subscription_id
  end
end
