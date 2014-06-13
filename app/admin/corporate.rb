ActiveAdmin.register User, :as => "CorporateUser" do

  controller do
    def scoped_collection
      User.corporate
    end
  end

  config.add_action_item :only => :show do
    link_to "Order History", history_admin_corporate_user_path(corporate_user)
  end



  menu :label => "Corporate Users"

  filter :home_number
  filter :email
  filter :post_code
  filter :first_name

  index do
    column :name
    column :email
    column :city 
    column :post_code
    column :company do |user|
      link_to user.company.name, ['admin', user.company] if user.company
    end
    #default_actions
    column "" do |user|
      link_to("View", admin_corporate_user_url(user), class: "member_link view_link")  + 
        link_to("Edit", edit_admin_corporate_user_path(user), class: "member_link view_link") +
        link_to("Delete", admin_corporate_user_url(user), class: "member_link view_link", method: :delete, confirm: "Are you sure?") +
        link_to("History", history_admin_corporate_user_path(user))
    end
  end

  show :title => :full_name do
    div :id => :user_detail do
      panel "User Detail" do 
        attributes_table_for corporate_user do
          row("Title") { corporate_user.title }
          row("Company") { corporate_user.company.try(:name) }
          row(:first_name)
          row(:surname)
          row(:address) { corporate_user.full_address }
          row(:home_number)
          row(:mobile_number)
          row(:email)
        end
      end
    end

    panel "Payment Method Detail" do
      if corporate_user.payment_detail
        attributes_table_for corporate_user.payment_detail do
          row(:card_type)
          row(:issue_date)
          row(:expiration_date)
          row(:card_holder_name)
          row(:credit_card_number)
          row(:security_code)
          row(:special_instructions)
        end
      elsif corporate_user.pre_authorization
        attributes_table_for corporate_user.pre_authorization do
          row(:pre_id)
          row(:go_user_id)
          row(:max_amount)
          row(:created_at)
        end
      end
    end
  end

  form do |f|
    if f.object.errors.any?
      p f.object.errors
    end
    f.object.build_payment_detail if f.object.payment_detail.nil?
    f.object.build_user_company if f.object.user_company.nil?
    f.inputs "Personal Info" do
      f.input :title, :as => :select, :collection => User::TITLES, :include_blank => "Select Title"
      f.inputs :for => :user_company do |c|
        c.input :company_id, :as => :select, :collection => Company.names_with_ids, :include_blank => "Select Company"
      end
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
    attributes_table_for corporate_user do
      row(:loyalty_points)
      row("Consumed") { (corporate_user.loyalty_points/100.0).ceil - corporate_user.discount_codes.loyalty_points.count  } 
      row("Unused Codes") { corporate_user.discount_codes.loyalty_points.count }
    end

  end
    sidebar :map, :only => :show do
      url = %{http://maps.googleapis.com/maps/api/staticmap?}
      center = "center=#{URI.encode(corporate_user.map_address)}, Mulan,PK&"
      zoom = "zoom=14&"
      scale = "scale=2&"
      width, height = 120, 120
      width, height = width * 2, height * 2 unless scale
      size = "size=#{width}x#{height}&"
      marker = "markers=color:blue|size:normal|#{URI.encode(corporate_user.map_address)},Multan,PK&"
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
