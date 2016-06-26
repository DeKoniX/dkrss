back_history_length = 0

back_click = ->
  back_history_length -= 1

click_url = ->
  back_history_length += 1

ready = ->
  $('#scrollup').click ->
    window.scroll(0, 0)
  $('#back').click ->
    if back_history_length > 0
      window.history.back()
    back_click()
  if back_history_length > 0
    $('#back').show()
  else
    $('#back').hide()

$(document).ready(ready)
$(document).on('page:load', ready)

document.addEventListener("turbolinks:load", ready)
document.addEventListener("turbolinks:click", click_url)

$(window).scroll ->
  if $(document).scrollTop() > 0
    $('#scrollup').fadeIn('fast')
  else
    $('#scrollup').fadeOut('fast')

