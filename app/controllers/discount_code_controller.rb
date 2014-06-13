class DiscountCodeController < ApplicationController

  def check_code
    discount_code = DiscountCode.find_by_discount_code params[:code]
    return render :text => "Code Accepted" unless discount_code.blank?
    render :text => "Discount Code invalid"
  end

end
