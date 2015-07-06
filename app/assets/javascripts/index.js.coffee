ready = ->
  $('#scrollup').click ->
    window.scroll(0, 0);

$(document).ready(ready)
$(document).on('page:load', ready)

$(window).scroll ->
  if $(document).scrollTop() > 0
    $('#scrollup').fadeIn('fast');
  else
    $('#scrollup').fadeOut('fast');
