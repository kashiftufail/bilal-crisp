ActiveAdmin.register AreaCode do

  menu :priority => 3
  #belongs_to :user

  #config.add_action_item do
  #  link_to "More Items", [:admin, AreaCode.first]
  #end
  #before_filter :only => :show do
  #  @per_page = 1
  #end
  filter :area_code, :as => :check_boxes, :collection => proc { AreaCode.all.map(&:area_code)}
  filter :area_name

  index do
    column :area_code
    column :area_name
    default_actions
  end

  show :title => :area_name do
    panel "Area Code Details" do 
      attributes_table_for area_code do
        row(:area_code)
        row(:area_name)
      end
    end
  end

  sidebar "Customers in this area", :only => :show do
    @users = User.where(:post_code => area_code.area_code) 
    unless @users.empty?
      table_for @users do |t|
        t.column("Name") { |user| link_to user.full_name, [:admin, user] }
      end
    else 
      blank_slate "No Customer In this area" do
      end
    end
  end

end
