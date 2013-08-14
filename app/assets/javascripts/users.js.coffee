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
			for error in data.responseJSON.message
				errors_list.append("<li>" + error + '</li>')
			$("#error_explanation").show()
      
	$(".profile_form")
    .bind "ajax:before", (event, data) ->  
      $("#form_message").hide()
      $("#form_message").html('')
    .bind "ajax:success", (event, data) ->
      $("#form_message").addClass('alert-success')
      $("#form_message").removeClass('alert-error')
      $("#form_message").show()
      $("#form_message").html(data.message)
    .bind "ajax:error", (event, data) ->
      $("#form_message").addClass('alert-error')
      $("#form_message").removeClass('alert-success')
      $("#form_message").show()
      $("#form_message").html(data.responseJSON.message)
      
  $('#school_not_present').click ->
    if $('#school_not_present').is(':checked')
      $('#create_other_school').fadeIn()
      $("#user_school_id").val($("#user_school_id option:first").val());
      $('#user_school_id').attr('disabled', true)
    else
      $('#create_other_school').hide()
      $('#user_other_school').val('')
      $('#user_school_id').attr('disabled', false)
			
    
jQuery ->
  new AvatarCropper()
  
class AvatarCropper
  constructor: ->
    $('#cropbox').Jcrop
      aspectRatio: 1
      setSelect: [0, 0, 600, 600]
      onSelect: @update
      onChange: @update
    
  update: (coords) =>
    $('#user_crop_x').val(coords.x)
    $('#user_crop_y').val(coords.y)
    $('#user_crop_w').val(coords.w)
    $('#user_crop_h').val(coords.h)