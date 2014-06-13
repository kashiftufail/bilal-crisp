class MainController < ApplicationController

  require 'monkeywrench'

  def subscribe_to_newsletter
    email = params[:email]
    if email =~ /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/
      MonkeyWrench::Config.new(:datacenter => 'us2', :apikey => 'd3332e0fb6f777a2cd03a809c7aa7e51-us2')
      list = MonkeyWrench::List.find_by_name("Crisp Newsletter")
      members = list.members.collect(&:email)
      unless members.include?(email)
        list.subscribe({:email => email, :html => true})
        flash[:subscription_notice] = "SUBSCRIPTION CONFIRMED!"
      else
        flash[:subscription_notice] = "Email address already Subscribed"
      end
    else
      flash[:subscription_notice] = "Please enter a valid email address"
    end
    redirect_to root_path
  end

  def service_area_checker
    ac = params[:area_code][0..3]
    area_code = AreaCode.find_by_area_code(ac.strip)
    if params[:method] == "ajax"
      return render :text => "We currently are not available in your area" if area_code.blank?
      return render :text => "We are available in your area"
    end
    redirect_to("/")
    flash[:service_area_checker_notice] = "We are available in your area"
    flash[:service_area_checker_notice] = "We currently are not available in your area" if area_code.blank?
  end

  def gocardless
    if params[:resource_id]
      object = GoCardless.confirm_resource params.symbolize_keys
      options = {
        :pre_id => object.id,
        :interval_length => object.interval_length,
        :interval_unit => object.interval_unit,
        :go_user_id => object.user_id,
        :max_amount => object.max_amount,
        :uri => object.uri,
        :created_at_time => object.created_at
      }
      @pre = current_user.create_pre_authorization(options)
      if @pre.new_record?
        redirect_to "/payment_details/new" and return
      else 
        redirect_to "/main/confirmation?go=true" and return
      end
    end
  end

  def confirmation
    @booking = session[:order]
    @payment_detail = current_user.payment_detail unless params[:go]
    @pre_authorization = current_user.pre_authorization
  end

  def forgot_password
    user = User.find_by_email params[:email]
    flash[:notice] = "Either email is invalid or user does not exist in our records"
    return render :template => 'main/forgot_password' if user.blank?
    UserMailer.password(user.new_password, user, request.host).deliver
    flash[:notice] = "We have sent you the password. Please check your inbox."
  end

  def reset_password
    if request.post?
      code = PasswordCode.find_by_code params[:code]
      return redirect_to login_path if code.blank?
      user = code.user
      user.reset_password(params[:new_password], params[:confirm_password])
      flash[:notice] = "Password Changed"
      return redirect_to login_path
    end
  end

  def contact
    render :layout => 'pages'
  end

  def media
    render :layout => 'pages'
  end

  def privacy_policy
    render :layout => 'pages'
  end
end
