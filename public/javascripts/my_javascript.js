$(function() {
  $(".datepicker2").datepicker({
    dateFormat: 'yy-mm-dd',
    onSelect: function(dateText, instance) {
      path = window.location.pathname;
      search = window.location.search;
      filter_location = path
      if(search) {
        console.log(search);
        if(/date=/.test(search)) {
          search = search.replace(/(date=)(\d{4}-\d{2}-\d{2})/, "$1"+dateText);
          path += search
        } else {
          path += search + "&date=" + dateText;
        }
        window.location = path;
        //window.location = path;
      } else {
        path += "?date=" + dateText;
        window.location = path;
      }
    }
  });

  $("table.left tr, table.right tr").hover(function() {
    $(this).toggleClass('hello');
  });

  $("table.left tr, table.right tr").click(function() {
    link = $(this).attr('data-link');
    window.location = link;
  });

  $(".clickable").hover(function() {
    $(this).toggleClass('hello');
  });

  $(".clickable").click(function() {
    link = $(this).data('link');
    window.location = link;
  });


  
  $("input.autocomplete").autocomplete({
    source: $("input.autocomplete").data('names'),
    select: function(event, ui) {
      price = ui.item.label.match(/-(\d+\.\d+)/)[1];
      console.log(price);
      $(this).closest('ol').find(".autocomplete_value").val(price);
    }
  });


  $("#add_items").live("click", function(e) {
    $parent = $(this).closest('li');
    fieldset = $parent.prev().clone().html();
    number = fieldset.match(/items_attributes_(\d{1,2})_name_input/)[1];
    number = parseInt(number, 10);
    number++;
    new_fieldset = fieldset.replace(/(items_attributes_)(\d{1,2})/gi, "$1"+number);
    new_fieldset = new_fieldset.replace(/\[(\d)\]/gi, "["+number+"]");
    $new_item = $('<fieldset class="inputs">' + new_fieldset + '</fieldset>');
    $new_item.find('input.autocomplete').autocomplete({ 
      source: $new_item.find('input.autocomplete').data('names'),
      select: function(event, ui) {
        price = ui.item.label.match(/-(\d+\.\d+)/)[1];
        console.log(price);
        $(this).closest('ol').find(".autocomplete_value").val(price);
      }
    });
    $parent.before($new_item);
    e.preventDefault();
  });


  $code_type = $("#discount_code_code_type");
  isLoyalty = $code_type.val();
  if(isLoyalty == "Loyalty") {
    $code_type.next().text("Points");
  } else {
    $code_type.next().text("Percentage");
  }

  $("#discount_code_code_type").change(function() {
    isLoyalty = $(this).val();
    if(isLoyalty == "Loyalty") {
      $code_type.next().text("Points");
    } else {
      $code_type.next().text("Percentage");
    }
  });


});

