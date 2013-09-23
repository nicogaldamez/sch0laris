# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#question_tag_tokens').tokenInput '/tags.json',
    preventDuplicates: true
    propertyToSearch: "description"
    hintText: ''
    prePopulate: $("#question_tag_tokens").data("load")
  if $('.pagination').length  
    $(window).scroll ->
      url = $('.pagination a.next_page').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
        Utils.loading(true)
        $('.pagination').text("Recuperando más items...")
        $.getScript(url + '&change_page=1')
    $(window).scroll

$ ->
  # Ask question
	$("#ask_form")
		.bind "ajax:complete", (event, data) ->
			$("#ask_form :submit").button "reset"
		.bind "ajax:before", (event, data) ->	
			$("#ask_form :submit").button "loading"
		.bind "ajax:success", (event, data) ->
			window.location.href = '/questions/' + data.question.id
  
	$("#answer_form")
		.bind "ajax:complete", (event, data) ->
			$("#answer_form :submit").button "reset"
		.bind "ajax:before", (event, data) ->	
			$("#answer_form :submit").button "loading"

  # Select best answer
	$(".select_best_answer")
		.bind "ajax:success", (event, data) ->
			best_answer = $(this).hasClass('best_answer')
			$('.select_best_answer').removeClass('best_answer')
			$('.select_best_answer').html('<i class="icon icon-star-empty"> </i>')
			if best_answer
        $(this).html('<i class="icon icon-star-empty"> </i>')
      else
        $(this).addClass('best_answer')
        $(this).html('<i class="icon icon-star"> </i>')
      
  $('.edit_answer')
    .bind "ajax:success", (event, data) ->
      $("html, body").animate({ scrollTop: $(document).height()-$(window).height() });
  register_answer_events()
  register_comments_events()
      
@register_answer_events = ->
	$(".vote_up")
		.bind "ajax:success", (event, data) ->
      count_container= $(this).closest('.votes').find('.number')
      refresh_vote_count(count_container, 1)
		.bind "ajax:error", (event, data) ->
			Utils.notify data.responseJSON.message, 'error'
  
	$(".vote_down")
		.bind "ajax:success", (event, data) ->
      count_container= $(this).closest('.votes').find('.number')
      refresh_vote_count(count_container, -1)
		.bind "ajax:error", (event, data) ->
			Utils.notify data.responseJSON.message, 'error'
  
  $(".leave_comment")
    .bind "ajax:success", (event, data) ->
      $(this).hide()
      comment_container = $(this).parent().parent().find('.new_comment')
      comment_container.html data
      comment_container.fadeIn()
      comment_container.find('textarea').focus()
      
	$(".delete_answer")
		.bind "ajax:success", (event, data) ->
			$(this).closest('.answer').fadeOut()
		.bind "ajax:error", (event, data) ->
			Utils.notify data.responseJSON.message, 'error'

@register_comments_events = ->
	$(".delete_comment")
		.bind "ajax:success", (event, data) ->
			$(this).closest('.comment').remove()
		.bind "ajax:error", (event, data) ->
			Utils.notify data.responseJSON.message, 'error'

@refresh_vote_count = (container, type)->
  value = parseInt(container.text()) + type
  container.fadeOut =>
    container.text(value).fadeIn() 
  
@new_comment = () ->
	$(".hide_comment").click (e) ->
    e.preventDefault()
    $(this).closest('.question_or_answer').find('.leave_comment').show()
    $(this).closest('.question_or_answer').find('.new_comment').hide().html('')
    
	$(".comment_form")
		.bind "ajax:complete", (event, data) ->
			$(".comment_form :submit").button "reset"
		.bind "ajax:before", (event, data) ->	
			$(".comment_form :submit").button "loading"    
		.bind "ajax:success", (event, data) ->
      comment_container = $(this).closest('.question_or_answer').find('.comments_list')
      comment_container.append(data).hide().fadeIn()
      $(this).closest('.question_or_answer').find('.leave_comment').show()
      $(this).closest('.question_or_answer').find('.new_comment').hide().html('')
      register_comments_events()
    
@cancel_answer_edit = ->
  window.location.reload()  
  