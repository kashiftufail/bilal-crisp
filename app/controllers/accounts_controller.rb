class AccountsController < ApplicationController

  before_filter :login_required

  def index
    @bookings = current_user.bookings
  end

  def order_history
    @bookings = current_user.bookings
  end

  def invite
    email_addresses = validate_email_address(params[:email_addresses].split(","))
    flash[:error] = "There were some invalid email address" unless params[:email_addresses].split(",").length == email_addresses.length
    UserMailer.invitation(email_addresses, current_user).deliver
    return redirect_to :action => 'refer_a_friend'
  end

  def loyalty_points
    @user = current_user
    render :layout => 'pages'
  end

  def address_book
    render :layout => 'pages'
  end

  def refer_a_friend
    render :layout => 'pages'
  end

  def send_loyalty_code
    UserMailer.loyalty_codes(current_user).deliver unless current_user.discount_codes.loyalty_points.blank?
    redirect_to :action => 'loyalty_points'
  end

  private

  def validate_email_address(email_addresses)
    emails = email_addresses
    emails.delete_if {|email| !(email =~ /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/) }
    emails
  end

end
