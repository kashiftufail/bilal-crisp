class UserCompany < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  validates :company_id, :presence => true
end
