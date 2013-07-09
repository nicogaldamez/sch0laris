# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#question_tag_tokens').tokenInput '/tags.json',
    preventDuplicates: true
    propertyToSearch: "description"
    hintText: ''

$ ->
	$("#ask_button").button()
	$("#ask_button").click ->
	  $(this).button "loading"
    
	$("#ask_form")
		.bind "ajax:complete", (event, data) ->
			$("#ask_button").button "reset"
		.bind "ajax:before", (event, data) ->	
			$("#ask_error").html('')
		.bind "ajax:success", (event, data) ->
			window.location.href = '/'
		.bind "ajax:error", (event, data) ->
			$("#ask_error").html(data.responseJSON.message)
	
