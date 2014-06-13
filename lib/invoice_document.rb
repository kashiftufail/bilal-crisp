#encoding: UTF-8
class InvoiceDocument < Prawn::Document
  def initialize(booking, view)
    super({:page_size => "A4"})
    @booking = booking
    @view = view
    logo_image
    company_info
    date_stamp
    customer_info
    billing_detail
  end

  def logo_image
     image File.open(Rails.root.join("public", "images", "logo.jpg")), :position => :right, :width => 150
  end

  def company_info
    float do  
      move_up 30
      text "Crisp", :style => :bold, :size => 20
      formatted_text([{:text => "DRY CLEANING & LAUNDARY", :size => 8, :color => "999999"}])
      text "[Street Address]"
      text "[City, ST, ZIP]"
      text "Phone: [000-000-0000]"
      formatted_text([{ :text => "Email: info@crispcleaners.co.uk", :style => :italic , :color => "777777"}])
    end 
  end

  def date_stamp
    float do  
      move_down 50
      date = Date.today.to_s
      invoice_id = @booking.id
      customer_id = @booking.user.id
      longest_size = date.size > invoice_id.to_s.size ? date.size : invoice_id.to_s.size
      longest_size = customer_id.to_s.size > longest_size ? customer_id.to_s.size : longest_size

      text("Date:\t\t\t #{' ' * (longest_size - date.size)} #{date}", :style => :bold, :align => :right)
      text "Invoice#\t\t\t #{' ' * longest_size} INV#{invoice_id}", :align => :right 
      text "Customer ID:\t\t\t #{' ' * longest_size } #{customer_id}", :align => :right
    end 
    move_down 60
  end

  def customer_info
    user = @booking.user
    table [
      ["Bill To"],[user.full_name], ["Company Name"], 
      [user.address], ["#{user.city},  #{user.post_code}"], ["Home:  " +user.home_number], ["Mobile: " + user.mobile_number]
    ], :cell_style => { :borders => [], :width => 200} do
      style(row(0), :background_color => '126799', :text_color => 'FFFFFF', :padding => 1)
      self.header = true
    end

    move_down 30
  end

  def billing_detail
    table [["Item", "Price", "Quantity", "Full Price"]] +
     @booking.items.map { |item| [
       item.name, 
       @view.number_to_currency(item.price, :unit => "£"),
       item.quantity, 
       @view.number_to_currency(item.total, :unit => "£")
    ] },
     :cell_style => { :borders => [:top, :bottom], :width => 130 } do
      style(row(0), :background_color => '126799', :text_color => 'FFFFFF')
      columns(1..3).align = :right
      self.header = true
    end
    move_down 20
    text "Surchage #{(@booking.surcharge*100).to_i}%", :size => 15, :align => :right
    move_down 5
    text "Discount #{@booking.co_discount}£", :size => 15, :align => :right
    move_down 5
    text "Total Price #{@booking.cost_with_discount_and_surcharge}£", :size => 15, :align => :right
  end

end
