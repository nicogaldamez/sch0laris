jQuery ->
	# // Inicio de sesión
	$(document).on "ajax:success", "#sign_in_form", (e, data, status, xhr) ->
	  $("#sign_in_error").text data.msg  if data.result is "ERROR"


