$('document').ready(function(){
    $(".check_box").click(function(){
      if($(this).attr("checked") == "checked");
        $('form').submit();
      return false;
    });
   $(".nav a").each(function(){
    if($(this).attr('href').replace("/","") == location.pathname.replace("/","")){
      $(this).parent().parent().addClass('current');
      $(this).parent().parent().removeClass('select');
    }
    else{
      $(this).parent().parent().removeClass('current');
      $(this).parent().parent().addClass('select');
    }
  });
    $( "#collection_date_filter" ).datepicker({
		  dateFormat: 'D, d MM, yy'
	  });
	  $( "#delivery_date_filter" ).datepicker({
		  dateFormat: 'D, d MM, yy'
	  });
});
