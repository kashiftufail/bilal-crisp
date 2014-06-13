# encoding: utf-8
ActiveAdmin.register Booking , :as => "Logistic" do

  menu :priority => 5
  actions :index, :show

  scope :all, :default => true
  scope :today_collection do |bookings|
    bookings.where("pickup_date BETWEEN ? AND ?", Time.now.beginning_of_day, Time.now.end_of_day)
  end
  scope :today_deliveries do |bookings|
    bookings.where("delivery_date BETWEEN ? AND ?", Time.now.beginning_of_day, Time.now.end_of_day)
  end

  filter :pickup_date
  filter :delivery_date

  index do
    column "Order ID", :sortable => :id do |booking|
      span booking.id
    end
    column :pickup_date
    column :delivery_date
    column "Order By"  do |booking|
      span booking.user.full_name
    end
    column :items_count
    column :surcharge do |booking|
      span number_to_percentage(booking.surcharge * 100, :precision => 0)
    end
    column :cost do |booking|
      span :class => "money" do
        number_to_currency(booking.cost, :unit => "&pound;")
      end
    end
    tr do
      td do
        link_to("Download Collection/Delivery Data", collection_data_admin_logistics_path(query_params))
      end
      td link_to("Download Address Data", address_data_admin_logistics_path(query_params))
    end
  end

  ############# EXPORT CSV FILES ##########################

  collection_action :collection_data do
    bookings
    @output = "collections #{@bookings.first.pickup_date}.csv"
    head = ["Order ID", "Pickup Date", "Delivery Date", "Order By", "Items Count", "Surcharge", "Cost"]
    puts csv_data = collection_csv(@bookings, head)
    send_data csv_data, :type => 'text/csv; charset=iso-8859-1; header=present',
      :disposition => "attachment; filename=#{@output}"
  end

  collection_action :address_data do
    # address is booking with users included 
    addresses
    @output = "addresses #{@bookings.first.pickup_date}.csv"
    head = ["Order ID", "First Name", "Surname", "Address", "Post Code", "Home Number", "Mobile Number"] 
    csv_data = address_csv(@bookings, head)
    send_data csv_data, :type => 'text/csv; charset=iso-8859-1; header=present',
      :disposition => "attachment; filename=#{@output}"
  end

  ########## HELPER METHODS ##########################
  controller do
    # not sure where to place helper methods
    private 

    def order_field
      if params[:order]
        # items_count_desc items_count is field, desc is order_direction
        order_directions = %w(asc desc)
        order_direction = params[:order].split("_").try(:last)
        field = params[:order].split("_#{order_direction}").try(:first) if order_directions.include?(order_direction)
        order_field = "#{field} #{order_direction}" if field
      end
    end

    def bookings
      if params[:q]
        @bookings = Booking.search(params[:q])
        @bookings = @bookings.relation.order(order_field) if params[:order].present?
        @bookings = @bookings.send(params[:scope]) if params[:scope].present?
      else
        @bookings = Booking.scoped
        @bookings = @bookings.order(order_field) if params[:order].present?
        @bookings = @bookings.send(params[:scope]) if params[:scope].present?
      end
      @bookings
    end

    def addresses
      bookings
    end

    include ActionView::Helpers::NumberHelper

    def collection_csv(resources, head)
      require 'csv'
      csv_data = CSV.generate do |csv|
        csv << head
        resources.each do |resource|
          csv << [
            resource.id,
            resource.pickup_date,
            resource.delivery_date,
            resource.user.full_name,
            resource.items_count,
            number_to_percentage(resource.surcharge * 100, :precision => 0),
            number_to_currency(resource.cost, :unit => "£".encode("iso-8859-1"))
          ]
        end
      end
      csv_data
    end

    def address_csv(resources, head)
      require 'csv'
      csv_data = CSV.generate do |csv|
        csv << head
        resources.each do |resource|
          user = resource.user
          csv << [
            resource.id,
            user.first_name,
            user.surname,
            user.address,
            user.post_code,
            user.home_number,
            user.mobile_number
          ]
        end
      end
      csv_data
    end
  end

end
