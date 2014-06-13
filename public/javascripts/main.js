$('document').ready(function(){
  $("#header_nav a").each(function(){
    if($(this).attr('href').replace("/","") == location.pathname.replace("/","")){
      $(this).addClass('highlighted');
    }
  });
  if($("#subscription_notice").length == 1){
    $("#subscription_notice").trigger('focus');
  }
  if($("#service_area_checker_notice").length == 1){
    $("#service_area_check").css('background','none');
    $("#service_area_check p").css('font-size','12px');
    $("#service_area_check p").css('text-align','left');
  }
});

