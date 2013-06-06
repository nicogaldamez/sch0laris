function toggle_sign_in() {
	// Limpio el formulario
	$(':input','#sign_in_form')
	  .not(':button, :submit, :reset, :hidden')
	  .val('');
		
	// Muestro el form
	$('#sign_in').slideToggle({duration: 200});
	
	// Tomo foco sobre el email
	$('#sign_in_email').focus();
}