class ApplicationController < ActionController::Base
  protect_from_forgery
  include AuthenticatedSystem
  
  def order_field
    if params[:order]
      # items_count_desc items_count is field, desc is order_direction
      order_directions = %w(asc desc)
      order_direction = params[:order].split("_").try(:last)
      field = params[:order].split("_#{order_direction}").try(:first) if order_directions.include?(order_direction)
      order_field = "#{field} #{order_direction}" if field
    end
  end

  helper_method :order_header, :order_field, :order_class

  def order_header(column, name)
    path = "#{request.path}?"
    unless order_field.try(:match, "#{column} desc")
      path << "order=#{column}_desc" 
      path << "&date=#{params[:date]}" if params[:date] && params[:order]
    else
      path << "order=#{column}_asc" 
      path << "&date=#{params[:date]}" if params[:date] && params[:order]
    end
    %{<a href="#{path}">#{name}</a>}.html_safe
  end

  def order_class(column)
    html_class = %{class="sortable"}
    logger.debug params[:order].try(:match, column.to_s);
    unless order_field.try(:match, "#{column} desc")
      html_class = %{class="sortable sorted-asc"} if params[:order].try(:match, column)
    else
      html_class = %{class="sortable sorted-desc"} if params[:order].try(:match, column)
    end
    html_class.html_safe
  end

  def bookings
    if params[:q]
      @bookings = Booking.search(params[:q])
      @bookings = @bookings.relation.order(order_field) if params[:order]
      @bookings = @bookings.send(params[:scope]) if params[:scope]
    else
      @bookings = Booking.scoped
      @bookings = @bookings.send(params[:scope]) if params[:scope]
      @bookings = @bookings.order(order_field) if params[:order]
    end
    @bookings
  end
end
