class CompaniesController < ApplicationController

  respond_to :json

  def show
    respond_with(Company.find(params[:id]))
  end
end
