class AreaCodesController < ApplicationController

  layout 'admin'

  def index
    @area_codes = AreaCode.all
  end

  def show
    @area_code = AreaCode.find(params[:id])
  end

  def new
    @area_code = AreaCode.new
  end

  def edit
    @area_code = AreaCode.find(params[:id])
  end

  def create
    @area_code = AreaCode.new(params[:area_code])

    if @area_code.save
      flash[:notice] = 'AreaCode was successfully created.'
      redirect_to(area_codes_url)
    else
      render :action => "new"
    end
  end

  def update
    @area_code = AreaCode.find(params[:id])

    if @area_code.update_attributes(params[:area_code])
      flash[:notice] = 'AreaCode was successfully updated.'
      redirect_to(area_codes_url)
    else
      render :action => "edit"
    end
  end

  def destroy
    @area_code = AreaCode.find(params[:id])
    @area_code.destroy
    redirect_to(area_codes_url)
  end
end
