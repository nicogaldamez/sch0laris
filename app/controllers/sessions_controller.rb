class SessionsController < ApplicationController
  
  def create
		user = User.find_by_email(params[:email].downcase)
		if user && user.authenticate(params[:password])
			sign_in user
			redirect_back_or user
		else
			@msg = t(:sign_in_error)
      respond_to do |format|
        format.json { render 'shared/error' }
      end
		end
	end
end
