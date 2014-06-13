class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.string :category, :limit => 30
      t.string :name, :limit => 20
      t.integer :price
    end
    add_index(:plans, [:category, :name], :unique => true)
    {
      :suit_and_shirt_plan => {:light => 60, :medium => 80, :heavy => 100, :pay_as_go => 0},
      :shirt_plan => {:light => 30, :medium => 40, :heavy => 50, :pay_as_go => 0}
    }.each do |category, plans|
      plans.each do |plan, price|
        Plan.create(:category => category, :name => plan, :price => price)
      end
    end
  end

  def self.down
    drop_table :plans
  end
end
