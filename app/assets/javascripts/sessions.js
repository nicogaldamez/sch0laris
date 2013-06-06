$(function() {
	// Inicio de sesión
	$(document).on('ajax:success', '#sign_in_form', function(e, data, status, xhr) {
		if (data.result == "ERROR") {
			$('#sign_in_error').text(data.msg);
		}	
	});	
});

