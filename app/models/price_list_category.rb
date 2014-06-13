class PriceListCategory < ActiveRecord::Base

  has_many :price_lists

  validates_presence_of :name
end
