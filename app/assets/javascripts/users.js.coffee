$ ->
	$("#sign_up_form")
		.bind "ajax:complete", (event, data) ->
			$("#sign_up_button").button "reset"
		.bind "ajax:success", (event, data) ->
			window.location.reload()
		.bind "ajax:error", (event, data) ->
			$("#sign_in_error").text data.responseJSON.msg

	$("#sign_up_button").button()
	$("#sign_up_button").click ->
	  $(this).button "loading"