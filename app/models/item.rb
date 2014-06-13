class Item < ActiveRecord::Base

  belongs_to :booking
  validates :price, :quantity, :numericality => true

  attr_accessor :total

  def total
    self.price * self.quantity
  end

end
