class AdminController < ApplicationController

  #before_filter :admin_login_required, :except => [:login]

  def index
    @bookings = Booking.scoped
  end

  def post_codes
    @post_codes = AreaCode.scoped
  end

  def user_order_history
    @user = User.find_by_id(params[:id])
    @bookings = @user.bookings
  end

  def user_loyalty_points
    @user = User.find_by_id(params[:id])
  end

  def update_orders
    orders_received = params[:orders_received]
    Booking.update_received_orders(orders_received) unless orders_received.blank?

    orders_dispatched = params[:orders_dispatched]
    Booking.update_dispatched_orders(orders_dispatched) unless orders_dispatched.blank?

    orders_confirmed = params[:orders_confirmed]
    Booking.update_confirmed_orders(orders_confirmed) unless orders_confirmed.blank?
    return redirect_to(:controller => 'bookings')
  end

  def create_discount_code
    if request.post?
      DiscountCode.create(params[:discount_code])
      flash[:notice] = "Discount Code created successfully"
    end
  end

  def download_notes
    booking = Booking.find(params[:id])
    path = "tmp/booking_instructions_#{booking.id}.xls"
    [booking].to_xls(:columns => ["id","customer_name","pickup_date","delivery_date", "address1", "address2","post_code","number"], :headers => ["Order ID","Customer Name","Collection Date","Delivery Date","First Line of Address","Second Line of Address" , "Post Code", "Telephone Number"]).write(path)
    send_file(path)
  end

  def download_address_data
    @bookings = Booking.all
    @bookings = Booking.where(["#{params[:filter]} = ?", params[:date].to_date]) if params[:filter]
    path = "tmp/address_data_#{params[:date]}.xls"
    @bookings.to_xls(:columns => ['pickup_date', 'delivery_date', "address", "city", "post_code"], :headers => ["Order Date", "Due Date","Address", "City", "Post Code"]).write(path)
    send_file(path)
  end

  def user_search
    @users = User.search(params[:search], params[:search_value])
    render :template => 'users/index'
  end

end
