class Booking < ActiveRecord::Base

  has_many :items, :dependent => :destroy
  has_one :bill
  accepts_nested_attributes_for :items, :allow_destroy => true, 
    :reject_if => proc { |attrs| attrs['name'].blank? || attrs['quantity'].blank? || attrs['price'].blank? }
  belongs_to :user

  validates_presence_of :pickup_date
  validates_presence_of :delivery_date

  STATUS = ["Pending", "Received", "Dispatched"]

  scope :pending, where(:status => 'Pending')
  scope :undispatched, where( ["status != 'Dispatched'"] )
  scope :completed, where(:status => 'Dispatched')

  scope :today_collection, where("pickup_date BETWEEN ? AND ?", Time.now.beginning_of_day, Time.now.end_of_day)
  scope :today_deliveries, where("delivery_date BETWEEN ? AND ?", Time.now.beginning_of_day, Time.now.end_of_day)

  scope :collection_by_date, lambda { |date, order_params| 
    beginning_of_day  = date.beginning_of_day
    end_of_day        = date.end_of_day 
    where(["pickup_date BETWEEN ? AND ?", beginning_of_day, end_of_day]).order(order_params)
  }

  scope :delivery_by_date, lambda { |date, order_params| 
    beginning_of_day  = date.beginning_of_day
    end_of_day        = date.end_of_day 
    where(["delivery_date BETWEEN ? AND ?", beginning_of_day, end_of_day]).order(order_params)
  }

  attr_accessor :address, :city, :customer_name, :address1, :address2, :post_code, :number

  before_update :count_cost
  after_update :send_email
  before_create :set_surcharge

  def send_email
    logger.debug "====================================="
    if self.status_changed? && self.status_was.eql?("Pending") && self.status.eql?("Received")
      UserMailer.order_received(self.user, self).deliver
    elsif self.status_changed? && self.status_was.eql?("Received") && self.status.eql?("Dispatched")
      UserMailer.order_dispatched(self.user, self).deliver
    end
    logger.debug "====================================="
  end

  def count_cost
    logger.debug "----------------"
      logger.debug self.items_count = self.items.inject(0) { |memo, object| 
        memo += object.quantity unless object.marked_for_destruction? 
        memo
      }
      logger.debug self.cost = self.items.inject(0) { |memo, object| 
        memo += object.total unless object.marked_for_destruction?
        memo
      }
    logger.debug self.to_yaml
    logger.debug "----------------"
  end

  def set_surcharge
    self.surcharge = self.delivery_date < (self.pickup_date + 2) ? 0.15 : 0.0
  end

  def set_surcharge_amout
    return 0.15 if self.delivery_date < (self.pickup_date + 2)
    0
  end

  def add_items(items)
    items_names = items[:name]
    items_quantities = items[:quantity]
    items_prices = items[:price]
    items_count = items_names.count
    items_count.times do |i|
      Item.create(:name => items_names[i], :price => items_prices[i], :quantity => items_quantities[i], :booking_id => self.id)
    end
  end

  def calculate_cost
    self.cost = self.items_count * 10
    self.discounted_cost
  end

  ######### COST CALCULATE (Ismail Dev) #######################
  

  def surcharge_amount
    extra_cost = self.cost.to_f.amount_of(self.surcharge*100)
  end

  def co_discount
    discount = DiscountCode.where(:discount_code => self.discount_code).first
    return discount.to_f if discount.nil?
    if discount.code_type.eql?("Discount") 
      amount = self.cost.amount_of(discount.value.to_f)
    elsif discount.code_type.eql?("Loyalty")
      amount = discount.value
    end
    amount
  end

  def cost_with_surcharge
    extra_cost = self.cost.to_f.amount_of(self.surcharge*100)
    total_with_surcharge = self.cost.to_f + extra_cost
    total_with_surcharge.round_to(2)
  end

  def cost_with_discount_and_surcharge
    return self.cost_with_surcharge if self.discount_code.blank?
    discount = DiscountCode.where(:discount_code => self.discount_code).first
    return self.cost_with_surcharge if discount.nil?
    if discount.code_type.eql?("Discount") 
      self.cost = self.cost.to_f - self.cost..to_f.amount_of(discount.value.to_f)
    elsif discount.code_type.eql?("Loyalty")
      self.cost = self.cost.to_f - discount.value
    end
    self.cost_with_surcharge
  end

  def cost_with_discount
    discount = DiscountCode.where(:discount_code => self.discount_code).first
    return self.cost if discount.nil?
    if discount.code_type.eql?("Discount") 
      self.cost = self.cost - self.cost.amount_of(discount.value.to_f)
    elsif discount.code_type.eql?("Loyalty")
      self.cost = self.cost - discount.value
    end
    self.cost
  end

  #############################################################

  def discounted_cost
    return self.cost if self.discount_code.blank?
    discount = DiscountCode.find_by_discount_code(self.discount_code)
    if discount.type == "Discount"
      cost = self.cost * 0.3
    elsif
      cost = self.cost-5
    end
    cost || self.cost
  end

  def self.update_received_orders(orders_received)

    orders_received.each do |id|
      order = Booking.find(id)
      unless order.status == "Received"
        order.status = "Received"
        order.save
        UserMailer.order_received(order.user, order).deliver
      end
    end

  end

  def customer_name
    self.user.name
  end

  def address
    self.user.address
  end

  def address1
    self.user.address1
  end

  def address2
    self.user.address2
  end

  def post_code
    self.user.post_code
  end

  def number
    self.user.home_number
  end

  def city
    self.user.city
  end

  def self.update_dispatched_orders(orders_dispatched)

    orders_dispatched.each do |id|
      order = Booking.find(id)
      unless order.status == "Dispatched"
        order.status = "Dispatched"
        order.save
        DiscountCode.create_discount_code(order.user) if order.user.bookings.count.zero? && !order.user.ref_id.blank?
        DiscountCode.create_loyalty_code(order.user) if (order.user.loyalty_points/ 100) >= order.user.discount_codes.loyalty_points.count
        UserMailer.order_dispatched(order.user, order).deliver
      end
    end

  end

end
class Float
  def round_to(x)
    (self * 10**x).round.to_f / 10**x
  end

  def amount_of(percentage)
    begin
      amount = (self / percentage.to_f)
      return amount.round_to(2)
    rescue 
      return 0;
    end
  end
end
