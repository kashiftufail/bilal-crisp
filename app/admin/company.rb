ActiveAdmin.register Company do

  filter :name

  actions :index, :show, :new, :create, :edit, :update

  index do
    column :name
    column :address, :sortable => :address do |company|
      company.full_address
    end
    column "Actions" do |company|
      %Q(#{link_to("View", ["admin", company])}
         #{link_to("Edit", edit_admin_company_url(company))}).html_safe
    end
  end

  show do
    panel "Company Detail" do
      attributes_table_for company do
        row :id
        row :name
        row :address
        row :city
        row :postal_code
      end
    end

    panel "Company Users" do 
      table_for company.users.order("id DESC") do
        column :id, :sortable => :id
        column("Name", :sortable => :name) do |user|
          link_to user.full_name, ["admin", user]
        end
        column :created_at
        column :updated_at
      end
    end
  end
end
