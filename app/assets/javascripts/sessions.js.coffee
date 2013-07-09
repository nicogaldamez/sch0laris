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
