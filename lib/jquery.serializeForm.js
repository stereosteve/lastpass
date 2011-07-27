$.fn.serializeForm = function(){
  var result = {};
  $.each($(this).serializeArray(), function(i, item){
    result[item.name] = item.value;
  });
  return result;
};

