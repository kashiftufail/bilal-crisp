class UserMailer < ActionMailer::Base
  default :from => "admin@crispcleaners.co.uk"

  def registration(user, password)
    subject = "Welcome to Crisp #{user.first_name}"
    @user, @password = user, password
    mail(:to => user.email, :subject => subject)
  end

  def corporate_registration(user, password)
    subject = "Welcome to Crisp #{user.first_name}"
    @user, @password = user, password
    mail(:to => user.email, :subject => subject)
  end


  def booking_confirmation(user, order)
    subject = "Crisp Dry Cleaning & Laundry Order Confirmation"
    @user, @order = user, order
    mail(:to => [user.email], :subject => subject)
  end

  def order_received(user, booking)
    subject = "Crisp Dry Cleaning & Laundry order breakdown confirmation"
    @user, @booking = user, booking
    mail(:to => [user.email], :subject => subject)
  end

  def order_dispatched(user, booking)
    subject = "Order Dispatch confirmation"
    @user, @booking = user, booking
    mail(:to => [user.email], :subject => subject)
  end

  def order_completed(user, booking)
    subject = "Confirmation of order completion by Crisp staff"
    @user, @booking = user, booking
    mail(:to => [user.email], :subject => subject)
  end
  
  def invitation(email_addresses, user)
    @user = user
    subject = "You have got a new request"
    mail(:to => [email_addresses], :subject => subject)
  end

  def loyalty_codes(user)
    @user, @loyalty_codes = user, user.discount_codes.loyalty_points
    subject = "Your Unused loyalty codes"
    mail(:to => [user.email], :subject => subject)
  end

  def loyalty_code(user, loyalty_code)
    @user, @loyalty_code = user, loyalty_code
    subject = "Your unused loyalty code"
    mail(:to => [user.email], :subject => subject)
  end

  def password(password, user, host)
    @user, @password, @host, @link = user, password, host, ["http://", host, "/p/",password].join
    subject      = "Your New Password"
    from         = 'noreply@crisp.com'
    mail(:to => [user.email], :subject => subject, :from => from)
  end

end
