class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead

  # render new.rhtml

  before_filter :authenticate_admin_user!, :only => [:index, :show, :destroy]
  before_filter :login_required, :only => [:my_account, :edit]
  before_filter :redirect_home, :only => [:new, :create]


  def index
    @users = User.scoped
    render :layout => 'admin'
  end

  def new
    @user = User.new
    @user.build_user_company
    @plan = Plan.where(:category => params[:category].try(:underscore), :name => params[:name].try(:underscore)).first
  end

  def create
    @user, @plan = User.create_with_plan(params)
    if @user.persisted?
      # if user is created by admin then redirect to users list page
      if logged_in? && current_user.admin?
        redirect_to users_url
      else
        if @plan && !@plan.name.pay_as_go?
          redirect_to subscription_url(@user)
        else
          redirect_to root_url, :notice => "Thanks for signing up!"
        end
      end
    else
      @user.build_user_company
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :new
    end
  end

  def show
    @user = User.find_by_id(params[:id])
    render :layout => 'admin'
  end

  def update
    @user = User.find_by_id(params[:id])
    @user.update_attributes(params[:user])
    flash[:notice] = "User details has been updated."
    if @user.errors
      @user.save(false) if current_admin_user
    end
    #return redirect_to users_path if current_user.admin? && !@user.admin?
    return redirect_to(account_path) if @user.errors.blank?
    flash[:error]  = "Could not update user details."
    render :action => 'edit'
  end

  def edit
    @user = User.find(params[:id])
  end

  def destroy
    user = User.find_by_id params[:id]
    user.destroy
    return redirect_to users_path
  end

  def change_password
  end

  def update_password
    unless current_user.update_password(params[:new_password], params[:confirm_password], params[:old_password])
      flash[:error] = "Password Could not be changed"
      return redirect_to :action => 'change_password'
    end
    flash[:notice] = "Password Changed successfully"
    return redirect_to :action => 'change_password'
  end

  protected

  def subscription_url(current_user)
    user_plan = current_user.user_plan
    plan = user_plan.plan
    options = {
      :amount => plan.price.to_s,
      :name => "Crisp Drycleaners subscription",
      :description => user_plan.description,
      :interval_unit => "month",
      :interval_length => 1,
      :expirate_at => 100.year.ago.iso8601,
      :state => user_plan.user_id
    }
    GoCardless.new_subscription_url(options)
  end

  def redirect_home
    if current_user
      user_plan = current_user.user_plan 
      logout unless current_user.corporate?
      if current_user && user_plan.nil?
        redirect_to request.referer || corporate_url  and return
      end
    end
  end

  def current_user
    @current_user ||= User.where(:id => session[:user_id]).first
  end

  def logout
    @current_user = session[:user_id] = nil
  end

end
