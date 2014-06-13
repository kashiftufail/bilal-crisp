#encoding: UTF-8
class InvoiceTemplate < Prawn::Document
  def initialize(booking, view)
    super({:page_size => "A4"})
    @booking = booking
    @view = view
    header
    invoice_info
    customer_info
    order_details
    billing_detail
    move_down 20
    text "Thank you for you Order!", :align => :center, :size => 16
  end

  def logo_image
     image File.open(Rails.root.join("public", "images", "logo.jpg")), :width => 150
  end

  def header
    logo_image
    float do
      move_up 25
      formatted_text([{:text => "Email: info@crispcleaners.co.uk", :size => 11, :color => "666666"}], :align => :center)
      move_up 12
      formatted_text([{:text => "Website: www.crispcleaners.co.uk", :size => 11, :color => "666666"}], :align => :right)
    end
  end

  def customer_info
    move_down 20
    user = @booking.user
    table [
      ["Bill To"],[user.full_name], 
      [user.address], ["#{user.city},  #{user.post_code}"], ["Home:  " +user.home_number], ["Mobile: " + user.mobile_number]
    ], :cell_style => { :borders => [], :width => 200} do
      style(row(0), :background_color => '126799', :text_color => 'FFFFFF', :padding => 1)
      self.header = true
    end

    move_down 10
  end

  def order_details
    move_down 20
    user = @booking.user
    table [
      ["Order Info", ""],
      ["Collection Date: ", @booking.pickup_date.strftime("%d/%m/%y")], 
      ["Deliver Date: ", @booking.delivery_date.strftime("%d/%m/%y")]
    ], :cell_style => { :borders => [], :width => 150} do
      style(row(0), :background_color => '126799', :text_color => 'FFFFFF', :padding => 2)
      style(row(1..2), :size => 15)
      self.header = true
    end

    move_down 30
  end

  def invoice_info
    float do  
      move_down 20
      date = Date.today.to_s
      invoice_id = @booking.id
      customer_id = @booking.user.id
      longest_size = date.size > invoice_id.to_s.size ? date.size : invoice_id.to_s.size
      longest_size = customer_id.to_s.size > longest_size ? customer_id.to_s.size : longest_size

      text("Date:\t\t\t #{' ' * (longest_size - date.size)} #{date}", :style => :bold, :align => :right)
      text "Invoice#\t\t\t #{' ' * longest_size} INV#{invoice_id}", :align => :right 
      text "Customer ID:\t\t\t #{' ' * (longest_size)  } #{customer_id}", :align => :right
    end 
  end

  def billing_detail
    table [["ITEM", "QTY", "PRICE", "TOTAL"]] +
     @booking.items.map { |item| [
       item.name, 
       item.quantity, 
       @view.number_to_currency(item.price, :unit => "£"),
       @view.number_to_currency(item.total, :unit => "£")
    ] },
     :cell_style => { :borders => [:top, :bottom], :width => 130 } do
      style(row(0), :background_color => '126799', :text_color => 'FFFFFF')
      columns(1..3).align = :right
      self.header = true
    end
    move_down 20
    if(@booking.surcharge_amount > 0)
    text "Surchage: £#{(@booking.surcharge_amount)}", :size => 15, :align => :right
    end
    if(@booking.co_discount > 0)
    move_down 5
    text "Discount: £#{@booking.co_discount}", :size => 15, :align => :right
    end
    move_down 5
    text "Total Price: £#{@booking.cost_with_discount_and_surcharge}", :size => 15, :align => :right
  end

end
