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
    
  # Ask question
	$("#ask_form")
		.bind "ajax:complete", (event, data) ->
			$("#ask_button").button "reset"
		.bind "ajax:before", (event, data) ->	
			$("#ask_error").html('')
		.bind "ajax:success", (event, data) ->
			window.location.href = '/'
		.bind "ajax:error", (event, data) ->
			$("#ask_error").html(data.responseJSON.message)
	
  # Answer question
	$("#answer_form")
		.bind "ajax:complete", (event, data) ->
			$("#answer_button").button "reset"
		.bind "ajax:before", (event, data) ->	
			$("#answer_message").html('')
		.bind "ajax:success", (event, data) ->
			$('#answer_body').val('')
		.bind "ajax:error", (event, data) ->
			$("#answer_message").html(data.responseJSON.message)
      
  $(".make_comment a").click ->
    $(this).prev('form').slideDown()
    $(this).prev('textarea').focus()
    $(this).parent().css({display: 'block'})
  $(".make_comment button.cancel_comment").click ->
    $(this).prev('textarea').val('')
    $(this).prev('form').slideUp()
    $(this).parent().css({display: 'none'})

vote = (answer_id, type, callback) ->
  $.ajax "/answers/" + answer_id + "/vote",
    type: "PUT"
    headers: 
      Accept: "application/json"
    data:
      type: type

    success: callback
    error: (data, textStatus, errorThrown) ->
    	notify data.responseJSON.message, 'error'
  false

@up_vote  = (answer_id) ->
  vote answer_id, 'up', ((plain, textStatus, data) ->
    value = parseInt($("#votes_" + answer_id).text()) + 1
    $("#votes_" + answer_id).fadeOut =>
      $("#votes_" + answer_id).text(value).fadeIn() 
  )
  false
  
@down_vote  = (answer_id) ->
  vote answer_id, 'down', ((plain, textStatus, data)->
    value = parseInt($("#votes_" + answer_id).text()) - 1
    $("#votes_" + answer_id).fadeOut =>
      $("#votes_" + answer_id).text(value).fadeIn() 
  )
  false
  
  