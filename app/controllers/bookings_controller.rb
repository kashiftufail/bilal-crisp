class BookingsController < ApplicationController

  #before_filter :admin_login_required, :only => [:index, :edit]
   skip_before_filter :verify_authenticity_token, :only => [:index] 

  def index
    @bookings = Booking.scoped
    @bookings = Booking.where(params[:sort_by]) if params[:sort_by]
    @bookings = Booking.where(['pickup_date = ?', params[:collection_date_filter].to_date]) if params[:collection_date_filter]
    @bookings = Booking.where(['delivery_date = ?', params[:delivery_date_filter].to_date]) if params[:delivery_date_filter]
    render :layout => 'admin'
  end

  def show
    @booking = Booking.find(params[:id])
    @payment_detail = @booking.user.payment_detail
    render :layout => 'admin'
  end

  def new
    return redirect_to(:controller => 'session', :action => 'new', :redirected => 1) unless logged_in?
    @booking = session[:order] || Booking.new
  end

  def edit
    @booking = Booking.find(params[:id])
    @user = @booking.user
    @discount_code = DiscountCode.find_by_discount_code(@booking.discount_code) if @booking.discount_code
    render :layout => 'admin'
  end

  def create
    @booking = Booking.new(params[:booking])

    @booking.surcharge = @booking.set_surcharge_amout
    @booking.user_id = current_user.id
    if @booking.valid?
      session[:order] = @booking
      redirect_to(:controller => 'payment_details', :action => 'new')
    else
      render :action => "new"
    end
  end

  def update
    @booking = Booking.find(params[:id])
    @user = @booking.user
    @user.attributes = @user.attributes.merge(params[:user])
    @user.save(false)
    if @booking.update_attributes(params[:booking])
      @booking.add_items(params[:item]) if params[:item]
      flash[:notice] = 'Booking was successfully updated.'
      redirect_to(:action => 'index')
    else
      render :action => "edit"
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy

    redirect_to(bookings_url)
  end

  def confirmation
    render :layout => 'pages'
    return if session[:order].blank?
    @booking = session[:order]
    @booking.save
    UserMailer.booking_confirmation(current_user, @booking).deliver
    session[:order] = nil
  end

  def discard
    session[:order] = nil
    redirect_to root_path
  end

  def booking_message
    time = Time.now
    date = params[:pickup_date].to_time
    return render :text => 'Sorry our next day service is available for booking up to 9:00AM for a same day collection:false' if time.gmtime.day == date.gmtime.day && time.gmtime.hour > 9
    return render :text => '15% surcharge will be applied to the order cost.:true'
  end

end
