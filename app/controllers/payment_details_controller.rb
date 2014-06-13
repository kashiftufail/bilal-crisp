class PaymentDetailsController < ApplicationController

  def index
    @payment_details = PaymentDetail.all
  end

  def show
    @payment_detail = PaymentDetail.find_by_id(params[:id])
    @pre_auth = current_user.pre_authorization
  end

  def new
    return redirect_to(:action => 'edit', :id => current_user.payment_detail.id, :redirected => true) unless current_user.payment_detail.blank?
    @payment_detail = PaymentDetail.new
  end

  def edit
    @payment_detail = current_user.payment_detail || PaymentDetail.find(params[:id])
    @booking = session[:order]
  end

  def create
    @payment_detail = PaymentDetail.new(params[:payment_detail])

    @payment_detail.user_id = current_user.id
    if @payment_detail.save
      flash[:notice] = 'PaymentDetail was successfully created.'
      return redirect_to(:action => 'show', :id => @payment_detail.id) if params[:redirected] == "false"
      redirect_to(:controller => 'main', :action => 'confirmation')
    else
      render :action => "new"
    end
  end

  def update
    @payment_detail = PaymentDetail.find(params[:id])

    if @payment_detail.update_attributes(params[:payment_detail])
      return redirect_to(:action => 'show', :id => @payment_detail.id) if params[:redirected] == "false"
      redirect_to(:controller => 'main', :action => 'confirmation')
    else
      render :action => "edit"
    end
  end

  def destroy
    @payment_detail = PaymentDetail.find(params[:id])
    @payment_detail.destroy

    redirect_to(payment_details_url)
  end

end
