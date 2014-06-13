module ApplicationHelper


  def plan_signup_path(plan_name)
    signup_path(:category => params[:action].dasherize, :name => plan_name)
  end

  def query_params
    params_without_path = {}
    params.each do |k, v|
      next if k == 'controller' || k == 'action'
      params_without_path.merge!({k.to_sym => v}) 
    end
    params_without_path 
  end

  def order_field
    if params[:order]
      # items_count_desc items_count is field, desc is order_direction
      order_directions = %w(asc desc)
      order_direction = params[:order].split("_").try(:last)
      field = params[:order].split("_#{order_direction}").try(:first) if order_directions.include?(order_direction)
      order = "#{field} #{order_direction}" if field
    end
    order
  end

  def order_field
    if params[:order]
      # items_count_desc items_count is field, desc is order_direction
      order_directions = %w(asc desc)
      order_direction = params[:order].split("_").try(:last)
      field = params[:order].split("_#{order_direction}").try(:first) if order_directions.include?(order_direction)
      order_field = "#{field} #{order_direction}" if field
    end
    order_field
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

  def class_name(path="")
    logger.debug request.fullpath
    return !!request.fullpath.match(%r{^#{path}$}) ? 'summary' : 'links'
  end

end
