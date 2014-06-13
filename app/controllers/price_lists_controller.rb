class PriceListsController < ApplicationController

  before_filter :authenticate_admin_user!, :only => [:new, :create, :edit, :update, :destroy]

  def index
    @price_list_categoies = PriceListCategory.all
    @dry_cleaning = PriceListCategory.find_by_name("Dry Cleaning")
    @laundry = PriceListCategory.find_by_name("Laundry Service")
    @household = PriceListCategory.find_by_name("Household")
    @repairs = PriceListCategory.find_by_name("Repairs/Alterations")
    @shirts = PriceListCategory.where(["name like ?", "%Shirt%"])
    @ironing = PriceListCategory.find_by_name("Ironing Service")
    @zip_replacement = PriceListCategory.find_by_name("Zip Replacement")
  end

  def show
    @price_list = PriceList.find(params[:id])
  end

  def new
    @price_list = PriceList.new
  end

  def edit
    @price_list = PriceList.find(params[:id])
  end

  def create
    @price_list = PriceList.new(params[:price_list])

    if @price_list.save
      flash[:notice] = 'Price List was successfully created.'
      redirect_to(price_lists_url)
    else
      render :action => "new"
    end
  end

  def update
    @price_list = PriceList.find(params[:id])

    if @price_list.update_attributes(params[:price_list])
      flash[:notice] = 'Price List was successfully updated.'
      redirect_to(price_lists_url)
    else
      render :action => "edit"
    end
  end

  def destroy
    @price_list = PriceList.find(params[:id])
    @price_list.destroy
    redirect_to(price_lists_url)
  end

end
