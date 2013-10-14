#encoding: UTF-8
root = exports ? this
root.visible_sign_in = false
root.search_input_state = 'cerrado'


@Utils =
  # Registra el evento para los tooltips
  mostrarTooltips: ->
    $("[data-toggle~=tooltip]").tooltip()
  
  # Muestra un div con un gif de carga. 
  # visible(bool) Indica si tiene que mostrarse o no
  # txt(string, default: 'cargando') El texto que se tiene que mostrar
  loading: (visible, txt) ->
    if visible
      if typeof(txt) == 'undefined'
        txt = 'cargando'
      $('#loading-bar span').text(txt)
      $('#loading-bar').show()  
    else
      $('#loading-bar').fadeOut()
      
  activeMenuItem: (menu, item) ->
    $("##{menu} li").removeClass('active')
    $("##{menu} li##{item}").addClass('active')
  
  notify: (msg, notify_type, auto_close) ->
      if typeof(auto_close) == 'undefined'
        auto_close = true
      alerts = $("#alerts")
      alerts.html msg
      alerts.removeClass("alert-error").addClass("alert alert-success").slideDown "fast"  if notify_type is "success"
      alerts.removeClass("alert-success").addClass("alert alert-error").slideDown "fast"  if notify_type is "error"
      if auto_close
        setTimeout (=>
          alerts.slideUp()
        ), 5000
  
  registerEditor: ->
    # Editores WYSIWYG
    $('.wysihtml5').wysihtml5 
    	"locale": "es-ES",
    	"font-styles": false, #Font styling, e.g. h1, h2, etc. Default true
    	"emphasis": true, #Italics, bold, etc. Default true
    	"lists": true, #(Un)ordered lists, e.g. Bullets, Numbers. Default true
    	"link": true, #Button to insert a link. Default true
    	"image": true, #Button to insert an image. Default true,
    	"color": false #Button to change color of font

          
jQuery ->
	Utils.mostrarTooltips()
	Utils.registerEditor()
  
	# Cuadro de búsqueda
	$("#search_container").mouseover ->
    
    if root.search_input_state == 'cerrado'
      root.search_input_state = 'abriendo'
      Notification.hide_notification_popover()
      $("#search").animate width: "toggle", 300, ->
        $("#search").focus()
        root.search_input_state = 'abierto'
  
	$("#search_container").mouseout ->
    if root.search_input_state == 'abierto'
      root.search_input_state = 'cerrando' 
      $("#search").animate width: "toggle", 300, ->
        root.search_input_state = 'cerrado'
        
      
  # $("#search").blur ->
#     if visible_search_input
#       root.visible_search_input = false
#       $("#search").animate width: "toggle"
  
	# File inputs
	$("input:file").change ->
		$("#upload-file-info").html($(this).val())
    
  # Links remotos. Registra los eventos para mostrar el loading
  # y el mensaje de error
	$(".remote_link")
		.bind "ajax:complete", (event, data) ->
			Utils.loading(false)
		.bind "ajax:before", (event, data) ->	
			Utils.loading(true)
		.bind "ajax:error", (event, data) ->
      if typeof(data.responseJSON) != 'undefined'
        Utils.notify data.responseJSON.message, 'error'

  
  # Notificaciones
  Notification.initialize()
  
  # GO TOP
  if $('#go_top')
    $(window).scroll ->
      if $(window).scrollTop() > 50
        $('#go_top').fadeIn()
      else
        $('#go_top').fadeOut()