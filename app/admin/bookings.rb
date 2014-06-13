ActiveAdmin.register Booking, :as => "Order Management" do
  
  menu :priority => 1

  before_filter :only => :index do
    redirect_to  orders_admin_order_managements_path
  end

  collection_action :orders do
    date              = params[:date].present? ? Date.parse(params[:date]) : Date.today
    @collections  = Booking.collection_by_date(date, order_field)
    @deliveries   = Booking.delivery_by_date(date, order_field)
    render :index
  end

  form do |f|
    f.object.items.build
    f.inputs "Order Details" do
      f.input :user, :input_html => { :readonly => true, :value => f.object.user.try(:full_name) }
      f.input :pickup_date, :as => :datepicker
      f.input :delivery_date, :as => :datepicker
      f.input :surcharge
      f.input :special_instructions, :input_html => {:class => 'autogrow', :rows => 10, :cols => 20, :maxlength => 10}
      f.input :status, :as => :radio, :collection => Booking::STATUS
      f.input :cost
      f.input :discount_code, :input_html => { :readonly => true }

      f.inputs "Order Items Details" do 
        f.inputs :for => :items do |item|
          item.input :name, :input_html => { :class => :autocomplete, 
            "data-names" => PriceList.order(:item_name).map {|obj| 
            {value: obj.item_name, label: "#{obj.item_name}-#{obj.price}"} }.to_json }
            item.input :quantity
            item.input :price, :input_html => { :class => :autocomplete_value }
            item.input(:_destroy, :as => :boolean, :wrapper_html => { :class => "last_element" })
        end
      f.commit_button :button_html => { :value => "Add Item", :id => "add_items"}
      end
    end
    f.buttons
  end


  show do
    span(text = order_management.status.eql?("Received") || order_management.status.eql?("Dispatched") ? 
         link_to("Generate Invoice", generate_invoice_admin_order_management_path) : "")
    span(order_management.user.pre_authorization && order_management.bill.nil? && order_management.status.eql?("Dispatched") ? 
         link_to("Take payment via gocardless", take_payment_admin_order_management_path) : "" )
    br
    panel "Order Details" do
      attributes_table_for order_management do
        row(:id)
        row(:pickup_date)
        row(:delivery_date)
        row(:surcharge)
        row(:user)
        row(:created_at)
        row(:updated_at)
        row(:special_instructions)
        row(:items_count)
        temp = { "Pending" => "warning", "Dispatched" => :ok, "Received" => :error }
        row(:status) {  status_tag(order_management.status, temp[order_management.status]) }
        row(:cost)
        row(:cost_with_surcharge)
        row(:cost_with_discount_and_surcharge)
        row(:discount_code)
      end
    end
  end

  member_action :take_payment do
    booking_id = params[:id]
    @booking = Booking.where(:id => booking_id).first
    @user = @booking.user
    @pre = @user.pre_authorization
    pre_auth = GoCardless::PreAuthorization.find(@pre.pre_id)
    @bill = pre_auth.create_bill(
      :amount => @booking.cost_with_discount_and_surcharge.to_s, 
      :name => "Order# #{@booking.id}"
    )
    options = {
      :amount => @bill.amount,
      :source_id => @bill.source_id,
      :created_at_time => @bill.created_at,
      :bill_id => @bill.id,
      :pre_user_id => @bill.user_id,
      :uri => @bill.uri,
      :pre_authorization_id => @pre.id,
    }
    
    @booking.create_bill(options)
    redirect_to admin_order_management_path(@booking), :notice => "Order billed successfully."
  end

  member_action :generate_invoice do
    booking_id = params[:id]
    pdf = InvoiceTemplate.new(Booking.where(:id => params[:id]).first, view_context)
    send_data pdf.render, :type => "application/pdf", :disposition => 'inline'
  end

#    status = {"Pending" => "error", "Dispatched" => "ok", "Warning" => "warning"}
#    column :pickup_date
#    column :delivery_date
#    column :status, :sortable => :status do |booking|
#      status_class = status[booking.status] ? status[booking.status] : " warning"
#      content_tag(:span, booking.status, :class => "status #{status_class}")
#    end
#    column "Dispatched" do |booking|
#      check_box_tag :dispatched, '1', (booking.status == 'Dispatched'), :disabled => (booking.status == 'Pending')
#    end
#    default_actions
#
#    div :class => :index_as_table do
#    panel "Delivery Details" do
#      table_for bookings, :class => "index_as_table" do |t|
#        t.column(:pickup_date)
#        t.column(:delivery_date)
#        t.column(:status) do |booking|
#          status_class = status[booking.status] ? status[booking.status] : " warning"
#          content_tag(:span, booking.status, :class => "status #{status_class}")
#        end
#      end
#    end
#    end


end
