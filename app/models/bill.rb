class Bill < ActiveRecord::Base
  belongs_to :pre_authorization
  belongs_to :booking
end
