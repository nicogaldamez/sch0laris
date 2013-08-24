# Muestro el form para login
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


$ ->
	$("#sign_in_loading").hide()
	$("#sign_in_error").hide()
	$("#sign_in_form")
		.bind "ajax:before", (event) ->
			$("#sign_in_error").hide()
			$("#sign_in_loading").show()
		.bind "ajax:success", (event, data) ->
			window.location.reload()
		.bind "ajax:error", (event, data) ->
			$("#sign_in_error").text data.responseJSON.message
			$("#sign_in_error").show()
			$("#sign_in_loading").hide()
