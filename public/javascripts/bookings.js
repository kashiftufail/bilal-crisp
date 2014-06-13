$('document').ready(function(){

      $("#new_booking").submit(function(){
        text = $('.error').text();
        if(/invalid/i.test(text))
        return false;
      });
      $("#new_item").click(function(){
        html = $("#order_breakdown").html();
        $("#items-form").append("<tr>" + html + "</tr>");
        $('.item-price').trigger('change');

        $('.item-price').change(function(){
        var total = 0;
        $('.item-price').each(function(){
          price = Number($(this).val());
          quantity = Number($(this).parent().parent().find('#item_quantity_').val());
          total +=  price * quantity;
          if ($('#discount').length > 0)
            total = total - $('#discount').val();
          $('#total_cost').val(total);
          $('#booking_cost').val(total);
        });
    });
        return false;
      });

    $('.item-price').change(function(){
      var total = 0;
      $('.item-price').each(function(){
        price = Number($(this).val());
        quantity = Number($(this).parent().parent().find('#item_quantity_').val());
        total +=  price * quantity;
        if ($('#discount').length > 0)
          total = total - $('#discount').val();
        $('#total_cost').val(total);
        $('#booking_cost').val(total);
      });
    });

      $("#next_day_service").click(function(){
        if($(this).attr('checked') == 'checked'){
          $.ajax({
            url: "/bookings/booking_message",
            data: {pickup_date : $("#pickup_date").val()},
            success: function( data ){
              var msg = data.split(":")[0]
              var success = data.split(":")[1]
              $("#time-notice p").html('<b style="font-size:13px;">' + msg + '</b>');
              $("#time-notice").show();
              if(success == "true" || success == true){
                delivery_date = new Date($("#delivery_date").val());
                delivery_date.setDate(delivery_date.getDate() - 1);
                $("#delivery_date").val($.datepicker.formatDate('D, d MM, yy',delivery_date));
              }
            }
          });
        }
        else{
          $("#time-notice").hide();
          day_diff = daydiff(new Date($('#pickup_date').val()), new Date($('#delivery_date').val()));
          if(day_diff < 2){
            delivery_date = new Date($("#delivery_date").val());
            delivery_date.setDate(delivery_date.getDate() + 1);
            $("#delivery_date").val($.datepicker.formatDate('D, d MM, yy',delivery_date));
          }
        }
      });

      $("#area_code_form").submit(function(){
        $.ajax({
            url: "/main/service_area_checker",
            data: {area_code:$("#txt_area_post_code").val(), method:"ajax"},
            success: function( data ) {
              $(".alert p").html(data);
            }
          });
        return false;
      });
      $("#booking_discount_code").change(function(){
        $.ajax({
          url: "/discount_code/check_code",
          data: {code:$("#booking_discount_code").val()},
          success: function( data ) {
            $("#code_result").text(data);
            $("#code_result").addClass('error');
          }
        });
      });
// ------- Calendar JS
      var pickup_date = $( "#pickup_date" ).datepicker({
			  defaultDate: "+1w",
			  minDate: $( "#pickup_date" ).val(),
			  dateFormat: 'D, d MM, yy'
		  });

    var delivery_date = $( "#delivery_date" ).datepicker({
			defaultDate: "+2",
			minDate: 1,
			maxDate: 2
		});

  $( "#pickup_date" ).change(function(){
    if($("#delivery_date").val() != "" && $("#delivery_date").val() != null){
      day_diff = daydiff(new Date($('#pickup_date').val()), new Date($('#delivery_date').val()));
    }
    else{
      day_diff = 0;
    }
    maxDate = new Date($("#pickup_date").val());
    maxDate.setDate(maxDate.getDate() + 2);

    minDate = new Date($("#pickup_date").val());;
    minDate.setDate(minDate.getDate() + 1)

    $('#delivery_date').datepicker('option', 'minDate', minDate);
    $('#delivery_date').datepicker('option', 'maxDate', maxDate);
    $("#delivery_date").val($.datepicker.formatDate('D, d MM, yy',maxDate));
  });

  $( "#delivery_date" ).change(function(){
    $.ajax({
      url: "/bookings/booking_message",
      data: {pickup_date : $("#pickup_date").val()},
      success: function( data ){
        var msg = data.split(":")[0]
        var success = data.split(":")[1]
        $("#time-notice p").text(msg);
        $("#time-notice").show();
        if(success == "true" || success == true){
          delivery_date = new Date($("#delivery_date").val());
          delivery_date.setDate(delivery_date.getDate());
          $("#delivery_date").val($.datepicker.formatDate('D, d MM, yy',delivery_date));
          $("#next_day_service").attr("checked","checked");
          $("#next_day_service").attr("disabled","disable");
          if(daydiff(new Date($('#pickup_date').val()), new Date($('#delivery_date').val())) > 1){
            $("#next_day_service").removeAttr("checked");
            $("#next_day_service").removeAttr("disabled");
            $("#time-notice").hide();
          }
        }
        else{
          $("#next_day_service").removeAttr("checked");
          $("#next_day_service").removeAttr("disabled");
          delivery_date = new Date($("#delivery_date").val());
          delivery_date.setDate(delivery_date.getDate() + 1);
          $("#delivery_date").val($.datepicker.formatDate('D, d MM, yy',delivery_date));
        }
      }
    });
  });

  if($("#next_day_service:checked").length == 0)
    $( "#pickup_date" ).trigger('change');
// End Calendar JS

   $(".remove_item").click(function(){
      $(this).parent().remove();
      $("#items #booking_items_count").val($("#items #item_container").length);
    return false;
  });

  $("#discount").change(function(){
    $("#discount_code").toggle();
  });
});

// Date Functions 

function daydiff(first, second) {
  return (second-first)/(1000*60*60*24)
}

function parseDate(str) {
    var mdy = str.split('/')
    return new Date(mdy[2], mdy[0]-1, mdy[1]);
}
