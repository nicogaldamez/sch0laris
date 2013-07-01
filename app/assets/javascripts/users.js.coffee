$ ->
	$("#sign_up_form")
		.bind "ajax:complete", (event, data) ->
			$("#sign_up_button").button "reset"
		.bind "ajax:before", (event, data) ->	
			$("#error_explanation").hide()
			$("#error_explanation ul").html('')
		.bind "ajax:success", (event, data) ->
			window.location.href = '/'
		.bind "ajax:error", (event, data) ->
			errors_list= $("#error_explanation ul")
			for error in data.responseJSON.msg
				errors_list.append("<li>" + error + '</li>')
			$("#error_explanation").show()
			

	$("#sign_up_button").button()
	$("#sign_up_button").click ->
	  $(this).button "loading"