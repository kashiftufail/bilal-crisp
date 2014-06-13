class Plan < ActiveRecord::Base

  has_many :user_plans
  has_many :users, :through => :user_plans

  def name
    ActiveSupport::StringInquirer.new(self['name'])
  end
end
