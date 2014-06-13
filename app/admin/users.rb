ActiveAdmin.register User do



  before_filter do
    #@per_page = 2
  end


  controller do
    def scoped_collection
      User.non_corporate
    end
  end

  config.add_action_item :only => :show do
    link_to "Order History", history_admin_user_path(user)
  end



  menu :label => "Customer Management", :priority => 2

  filter :home_number
  filter :email
  filter :post_code
  filter :first_name

  index do
    column :name
    column :email
    column :city 
    column :post_code
    #default_actions
    column "" do |user|
      link_to("View", [:admin, user], class: "member_link view_link")  + 
        link_to("Edit", edit_admin_user_path(user), class: "member_link view_link") +
        link_to("Delete", [:admin, user], class: "member_link view_link", method: :delete, confirm: "Are you sure?") +
        link_to("History", history_admin_user_path(user))
    end
  end

  show :title => :full_name do
    div :id => :user_detail do
      panel "User Detail" do 
        attributes_table_for user do
          row("Title") { user.title }
          row(:first_name)
          row(:surname)
          row(:address) { user.full_address }
          row(:home_number)
          row(:mobile_number)
          row(:email)
        end
      end
    end

    panel "Payment Method Detail" do
      if user.payment_detail
        attributes_table_for user.payment_detail do
          row(:card_type)
          row(:issue_date)
          row(:expiration_date)
          row(:card_holder_name)
          row(:credit_card_number)
          row(:security_code)
          row(:special_instructions)
        end
      elsif user.pre_authorization 
        attributes_table_for user.pre_authorization do
          row(:pre_id)
          row(:go_user_id)
          row(:max_amount)
          row(:created_at)
        end
      end
    end
  end

  form do |f|
    f.object.build_payment_detail if f.object.payment_detail.nil?
    f.inputs "Personal Info" do
      f.input :title, :as => :select, :collection => User::TITLES, :include_blank => "Select Title"
      f.input :first_name
      f.input :surname
      f.input :address_first, :label => "Address Line 1"
      f.input :address_last, :label => "Address Line 2"
      f.input :city
      f.input :post_code
      f.input :home_number, :label => "Primary Number", :as => :phone
      f.input :mobile_number, :label => "Mobile Number", :as => :phone
      f.input :email, :as => :email
      f.input :password, :as => :password
      f.input :password_confirmation, :as => :password
      f.inputs "Payment details" do
        f.inputs :for => :payment_detail do |p|
          p.input :card_type, :as => :select, :collection => PaymentDetail::CREDIT_CARDS, :include_blank => "Choose One"
          p.input :issue_date, :as => :datepicker
          p.input :expiration_date, :as => :datepicker
          p.input :credit_card_number
          p.input :security_code
          p.input :card_holder_name
          p.input :special_instructions, :input_html => {:class => 'autogrow', :rows => 10, :cols => 20, :maxlength => 10}
        end
      end
    end
    f.buttons
  end

  sidebar :loyality_points, :only => :show do
    attributes_table_for user do
      row(:loyalty_points)
      row("Consumed") { (user.loyalty_points/100.0).ceil - user.discount_codes.loyalty_points.count  } 
      row("Unused Codes") { user.discount_codes.loyalty_points.count }
    end

  end
    sidebar :map, :only => :show do
      url = %{http://maps.googleapis.com/maps/api/staticmap?}
      center = "center=#{URI.encode(user.map_address)}, Mulan,PK&"
      zoom = "zoom=14&"
      scale = "scale=2&"
      width, height = 120, 120
      width, height = width * 2, height * 2 unless scale
      size = "size=#{width}x#{height}&"
      marker = "markers=color:blue|size:normal|#{URI.encode(user.map_address)},Multan,PK&"
      sensor = "sensor=false"
      map_url = url + center + zoom + size + scale + marker + sensor
      image_tag map_url
    end

  member_action :history  do
    @user = User.where(:id => params[:id]).first
    @page_title = "#{@user.full_name} orders history"
    @bookings = @user.bookings.order("id DESC").page(params[:page]).per(10)
  end

end
