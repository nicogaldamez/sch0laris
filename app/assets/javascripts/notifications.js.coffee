# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
@Notification = 
  initialize: ->
    if $("#notifications_link").length > 0
      $("#notifications_link").click @show_notifications
    
      $(":not(#anything)").on "click", (e) ->
        $(".popover-link").each ->    
          #the 'is' for buttons that trigger popups
          #the 'has' for icons and other elements within a button that triggers a popup
          if not $(this).is(e.target) and $(this).has(e.target).length is 0 and $(".popover").has(e.target).length is 0
            $(this).popover "hide"
            return
      @request()
      @poll()

  show_notifications: (e)->
  	if !($('#search').is(':visible'))
      e = $(this)
      url = $(this).data('url')

      $.get url, (d) -> 
        e.popover(
          html: true, 
          placement: 'bottom'
        ).popover("show")
        $('.popover.in .popover-inner .popover-content').empty()
        $('.popover.in .popover-inner .popover-content').html(d)
    
  hide_notification_popover: ->
    $("#notifications_link").popover('hide')
    
  poll: ->
    setTimeout @request, 10000

  request: ->
    $.get($('#notifications_link').data('pollurl'), (data, textStatus)->
      if data.unread_count != "0"
        if !$('#notifications_link').hasClass('new_notifications')
          $('#notifications_link').addClass('new_notifications')
          $('#notification_number').text(data.unread_count).show()
      else
        $('#notifications_link').removeClass('new_notifications')
        $('#notification_number').hide()
    )
    Notification.poll()