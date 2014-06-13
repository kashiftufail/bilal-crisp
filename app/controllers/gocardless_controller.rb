class GocardlessController < ApplicationController

  def subscription_callback
    logger.debug GoCardless.confirm_resource params
    subscription_id = params[:resource_id]
    user_id         = params[:state]
    user            = User.where(:id => user_id).first
    user_plan       = user.try(:user_plan)
    user_plan.update_attribute(:subscription_id, subscription_id) unless user_plan.nil?
    session[:user_id] = user_id unless user.nil?
    redirect_to root_url
  end
end
