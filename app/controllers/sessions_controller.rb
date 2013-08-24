class SessionsController < ApplicationController
  
  def create
    raise(RequestExceptions::BadRequestError.new(t(:missing_params))) unless check_params?(['email','password'])
    
		user = User.find_by_email(params[:email].downcase)
		if user && user.authenticate(params[:password])
      sign_in user
			redirect_to user_path(user, format: :json)
		else
			raise(RequestExceptions::BadRequestError.new(t(:sign_in_error)))
		end
	end
  
  def destroy
    sign_out
    redirect_to root_url
  end
  
  def social_network_callback
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted?
      sign_in user
      if user.email.blank?
        flash.notice = t(:complete_your_profile)
        redirect_to profile_personal_path
      else
        redirect_to root_url
      end
    else
      redirect_to new_user_url
    end
  end
  
  def oauth_failure
    raise params
    flash[:error] = 'Error'
    redirect_to root_url 
  end
end
