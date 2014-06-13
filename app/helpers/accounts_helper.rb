module AccountsHelper

  def unused_loyalty_codes
    @user.discount_codes.loyalty_points.count unless @user.discount_codes.blank?
  end

end
