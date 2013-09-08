jQuery ->
  $('#faq_menu a').click ->
    $('#faq_menu li').removeClass('active')
    $(this).closest('li').addClass('active')