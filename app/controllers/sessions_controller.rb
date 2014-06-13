class SessionsController < ApplicationController

  layout 'users'

  def new
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:home_number], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      #return redirect_to admin_path if current_user.admin?
      #return redirect_to new_booking_path
      redirect_to corporate_path and return if user.corporate?
      return redirect_to root_url
      redirect_back_or_default('/')
      flash[:notice] = "Logged in successfully"
    else
      note_failed_signin
      @email       = params[:email]
      @remember_me = params[:remember_me]
      flash[:error] = "Invalid Number or password"
      return render :layout => 'admin', :template => 'admin/login' if params[:admin]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

  protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end

end
