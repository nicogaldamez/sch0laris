root = exports ? this
root.visible_sign_in = false
@toggle_sign_in = ->
  
  # Limpio el formulario
  $(":input", "#sign_in_form").not(":button, :submit, :reset, :hidden").val ""
  
  # Muestro el form
  $("#sign_in").slideToggle duration: 200
  main_padding = (if (visible_sign_in) then "0px" else "120px")
  $("#main_container").animate
    "padding-top": main_padding
  , 200
  
  # Tomo foco sobre el email
  $("#sign_in_email").focus()
  root.visible_sign_in = not visible_sign_in

root.visible_search_input = false
$ ->
  $("#search_container").mouseover ->
    $("#search").focus()
    unless visible_search_input
      root.visible_search_input = true
      $("#search").animate width: "toggle"

  $("#search").blur ->
    if visible_search_input
      root.visible_search_input = false
      $("#search").animate width: "toggle"

@mostrarTooltips = ->
  $("[data-toggle~=tooltip]").tooltip()


$ ->
  mostrarTooltips()