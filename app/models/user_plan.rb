class UserPlan < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan

  def description
    plan = self.plan
    return plan ? "#{plan.category} #{plan.name}".humanize : ""
  end
end
