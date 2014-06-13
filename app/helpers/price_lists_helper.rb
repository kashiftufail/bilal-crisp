# coding: utf-8
module PriceListsHelper

  def formatted_price(price)
    if price.to_i == 0
      return "FREE"
    elsif price.to_s.split(".").last.length < 2
      price =  [price.to_s, "0"].join
    end
    ["£",price].join
  end

end
