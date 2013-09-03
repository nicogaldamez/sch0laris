module AuthTestHelper

  class SessionBackdoorController < ::ApplicationController
    def create
      sign_in User.find(params[:user_id])
      head :ok
    end
  end

  begin
    _routes = Rails.application.routes
    _routes.disable_clear_and_finalize = true
    _routes.clear!
    Rails.application.routes_reloader.paths.each{ |path| load(path) }
    _routes.draw do
      # here you can add any route you want
      match "/test_login_backdoor", to: "sessions#create"
    end
    ActiveSupport.on_load(:action_controller) { _routes.finalize! }
  ensure
    _routes.disable_clear_and_finalize = false
  end

  def request_signin_as(user)
    visit "/test_login_backdoor?user_id=#{user.id}"
  end

  def signin_as(user)
    session[:session_user] = user.id
  end

end