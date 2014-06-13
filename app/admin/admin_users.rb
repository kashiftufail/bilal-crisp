ActiveAdmin.register AdminUser do

  config.clear_sidebar_sections!

  before_filter do
    @is_admin = current_admin_user.roles.map(&:name).include?("admin")
    redirect_to [:admin] unless @is_admin
  end

  before_filter :only => :destroy do
    if current_admin_user.id == params[:id].to_i
      flash[:notice] = "You can't delete yourself"
      redirect_to [:admin, :admin_user]
    end
  end



  menu :if => proc { current_admin_user.roles.map(&:name).include?("admin") }

  index do
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    column do |user|
      link_to("View", admin_admin_user_path(user), :class => "member_link view_link") +
      link_to("Edit", edit_admin_admin_user_path(user), :class => "member_link view_link") +
      ( current_admin_user.id != user.id ? link_to("Delete", admin_admin_user_path(user), 
              :method => :delete, 
              :confirm => "Are you sure?", 
              :class => "member_link view_link") : "" )
    end
  end

  form do |f|
    f.inputs "Login Details" do
      f.input :email, :as => :email
      f.input :password, :as => :password
      f.input :roles, :as => :check_boxes, :collection => Role.all
    end
    f.buttons
  end

  controller do
    @name = false
  end

end
