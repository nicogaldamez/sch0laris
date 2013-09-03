module SessionsHelper

	def sign_in(user)
    session[:user_id] = user.id
		self.current_user = user
	end
	
	def signed_in?
    
		!@current_user.nil?
	end
	
	def current_user=(user)
		@current_user = user
	end
	
	def current_user 
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
	end
	
	def current_user?(user)
		user == current_user
	end
	
	def sign_out	
		self.current_user = nil
    session[:user_id] = nil
	end
	
	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end
	
	def store_location
		session[:return_to] = request.url
	end
	
	def signed_in_user
    unless signed_in?
      @message = t(:please_sign_in)
      respond_to do |format|
        format.html do
          redirect_to root_url, notice: t(:please_sign_in) 
        end
        format.js { render 'shared/error' }
        format.json do
          raise(RequestExceptions::UnauthorizedError.new(t(:please_sign_in)))
        end
      end
  	end
	end
end
