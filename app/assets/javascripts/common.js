visible_sign_in = false;
function toggle_sign_in() {
	// Limpio el formulario
	$(':input','#sign_in_form')
	  .not(':button, :submit, :reset, :hidden')
	  .val('');
		
	// Muestro el form
	$('#sign_in').slideToggle({duration: 200});
	
	var main_padding = (visible_sign_in) ? "0px" : "120px";
	$('#main_container').animate({
	    'padding-top': main_padding
	  }, 200);
	
	// Tomo foco sobre el email
	$('#sign_in_email').focus();
	
	visible_sign_in = !visible_sign_in;
}

visible_search_input = false;
$(function() {
	
	$("#search_container").mouseover(
	  function () {
			$("#search").focus();
			if (!visible_search_input) {
				visible_search_input = true;
				$("#search").animate({ width: 'toggle'});
			}
	  }
	);
	
	$("#search").blur(
	  function () {
			if (visible_search_input) {
	   		visible_search_input = false;
				$("#search").animate({ width: 'toggle'});
			}
			
	  }
	);
	
});


