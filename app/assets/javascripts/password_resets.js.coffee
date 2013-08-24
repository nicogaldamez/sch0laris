$ -> 
  $("#password_reset_form")
    .bind "ajax:before", (event, data) ->  
      Utils.loading(true)
    .bind "ajax:complete", (event, data) ->  
      Utils.loading(false)
    .bind "ajax:success", (event, data) ->
      # notify data.message, 'success'
      window.location = '/'
    .bind "ajax:error", (event, data) ->
      Utils.notify data.message, 'error'