module BookingsHelper

  def formatted_current_date
    Date.current.strftime("%a, %d %B, %Y")
  end

  def formatted_date(date)
    date.strftime("%a, %d %B, %Y")
  end

  def formatted_booking_pickup_date
    if @booking && !@booking.pickup_date.blank?
      formatted_date(@booking.pickup_date)
    elsif Time.now.hour > 9
      formatted_date(Date.current + 1)
    else
      formatted_current_date
    end
  end

  def next_day_service(order)
    return "Yes" if order.delivery_date == (order.pickup_date + 1)
    "No"
  end

  def admin_class(index)
    'class="alternate-row"' if index%2 == 0
  end

  def disabled_received(booking)
    booking.status == "Dispatched" || booking.cost.blank?
  end

  def disabled_dispatched(booking)
    booking.status != "Received" || booking.cost.blank?
  end

  def discount_value
    return 5 if @discount_code.code_type == "Loyalty"
    return (@booking.cost * 0.3) if @discount_code.code_type == "Discount"
  end

  def booking_cost
    return @booking.items.sum(:price) unless @booking.items.blank?
    0
  end

end
