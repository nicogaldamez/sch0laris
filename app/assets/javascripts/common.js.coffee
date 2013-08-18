root = exports ? this
root.visible_sign_in = false
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

root.visible_search_input = false

$ ->
  $("#search_container").mouseover ->
    $("#search").focus()
    unless visible_search_input
      hide_notification_popover()
      root.visible_search_input = true
      $("#search").animate width: "toggle"

  $("#search").blur ->
    if visible_search_input
      root.visible_search_input = false
      $("#search").animate width: "toggle"

@mostrarTooltips = ->
  $("[data-toggle~=tooltip]").tooltip()

@loading = (visible, txt) ->
  if visible
    if typeof(txt) == 'undefined'
      txt = 'cargando'
    $('#loading-bar span').text(txt)
    $('#loading-bar').show()  
  else
    $('#loading-bar').fadeOut()

$ ->
	mostrarTooltips()
	$("input:file").change ->
		$("#upload-file-info").html($(this).val())
	$(".remote_link")
		.bind "ajax:complete", (event, data) ->
			loading(false)
		.bind "ajax:before", (event, data) ->	
			loading(true)
		.bind "ajax:error", (event, data) ->
			notify data.responseJSON.message, 'error'

  # Editores WYSIWYG
  $('.wysihtml5').wysihtml5 
  	"locale": "es-ES",
  	"font-styles": false, #Font styling, e.g. h1, h2, etc. Default true
  	"emphasis": true, #Italics, bold, etc. Default true
  	"lists": true, #(Un)ordered lists, e.g. Bullets, Numbers. Default true
  	"link": true, #Button to insert a link. Default true
  	"image": false, #Button to insert an image. Default true,
  	"color": false #Button to change color of font
    
  # Notificaciones
  $("#notifications_link").click ->
      e = $(this)

      $.get '/notifications', (d) ->
        e.popover(
          content: d, 
          html: true, 
          placement: 'bottom',
          title: 'Notifications'
        ).popover "show"
      
      # $(".popover").off("click").on "click", (e) ->
#         e.stopPropagation() # prevent event for bubbling up => will not get caught with document.onclick
      
    
  $(":not(#anything)").on "click", (e) ->
    $(".popover-link").each ->    
      #the 'is' for buttons that trigger popups
      #the 'has' for icons and other elements within a button that triggers a popup
      if not $(this).is(e.target) and $(this).has(e.target).length is 0 and $(".popover").has(e.target).length is 0
        $(this).popover "hide"
        return
  
@hide_notification_popover = ->
  $("#notifications_link").popover('hide')  
  
@activeMenuItem = (menu, item) ->
  $("##{menu} li").removeClass('active')
  $("##{menu} li##{item}").addClass('active')
  
@notify = (msg, notify_type) ->
    alerts = $("#alerts")
    alerts.html msg
    alerts.removeClass("alert-error").addClass("alert alert-success").slideDown "fast"  if notify_type is "success"
    alerts.removeClass("alert-success").addClass("alert alert-error").slideDown "fast"  if notify_type is "error"
    setTimeout (=>
      alerts.slideUp()
    ), 4000
