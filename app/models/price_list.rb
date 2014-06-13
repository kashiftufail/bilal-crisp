class PriceList < ActiveRecord::Base

  belongs_to :price_list_category

  validates_presence_of :item_name
  validates_presence_of :price

end
