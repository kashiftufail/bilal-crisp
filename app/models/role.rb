class Role < ActiveRecord::Base

  validates_presence_of :name

  has_many :admin_roles
  has_many :admin_users, :through => :admin_roles
end
