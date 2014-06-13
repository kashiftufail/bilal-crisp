ActiveAdmin.register DiscountCode do

  menu :priority => 4
  config.clear_sidebar_sections!
  form do |f|
    f.inputs "Code Details" do
      f.input :user, :as => :select, :collection => User.order(:name).map{|user| ["#{user.first_name} #{user.surname}", user.id]}, :include_blank => "Select User", :hint => "(optional)"
      f.input :discount_code #, :input_html => { :value => DiscountCode.generate_random_code }
      f.input :code_type, :as => :select, :collection => DiscountCode::CODE_HASH, :include_blank => false, :hint => "hi"
      f.input :value
      f.input :start_date, :as => :datepicker
      f.input :end_date, :as => :datepicker
    end
    f.buttons
  end

  index do
    column :discount_code
    column :code_type
    column :start_date
    column :end_date
    column "Value" do |code|
      span :class => "money" do
        code.code_type == 'Discount' ? 
        number_to_percentage(code.value) : number_to_currency(code.value, :unit => "&pound;", :format => "%n%u")
      end
    end
    default_actions
  end

end
