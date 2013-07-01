class SessionsController < ApplicationController
  
  def create
    raise(RequestExceptions::BadRequestError.new(t(:no_params))) unless check_params?(['email','password'])
    
		user = User.find_by_email(params[:email].downcase)
		if user && user.authenticate(params[:password])
			sign_in user
			redirect_back_or user
		else
			RequestExceptions::BadRequestError.new(t(:sign_in_error))
		end
	end
  
  def destroy
    sign_out
    redirect_to root_url
  end
end
