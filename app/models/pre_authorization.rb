class PreAuthorization < ActiveRecord::Base
  belongs_to :user
  has_many :bills, :dependent => :destroy
end
