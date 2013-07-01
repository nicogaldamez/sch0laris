require "request_exceptions"

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  
  rescue_from RequestExceptions::BadRequestError, :with => :bad_request
  rescue_from RequestExceptions::ForbiddenError, :with => :forbidden
  rescue_from RequestExceptions::UnauthorizedError, :with => :unauthorized
  
  include SessionsHelper
  
  
  before_filter :set_locale
  
  # Setea el idioma del usuario
  # Lo saca del parametro locale o el header HTTP_ACCEPT_LANGUAGE
  # si el locale no está seteado
  def set_locale
    logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
    I18n.locale = params[:locale] || extract_locale_from_accept_language_header
    logger.debug "* Locale set to '#{I18n.locale}'"
    Rails.application.routes.default_url_options[:locale]= I18n.locale 
  end
  
  def check_params?(required)
    return true if required.blank?
    return false if params.blank? 
    required.each do | param |
      return false if params[param].blank? 
    end
    true
  end
  
  
  private
    def extract_locale_from_accept_language_header
      request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end
    
    # REQUEST ERRORS
    def bad_request (exception)    
			@msg = exception.message
      render 'shared/error', status: 400
      return
    end
  
    def forbidden    
    end
  
    def unathorized    
    end
end
