require "request_exceptions"

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from RequestExceptions::BadRequestError, :with => :bad_request
  rescue_from RequestExceptions::ForbiddenError, :with => :forbidden
  rescue_from RequestExceptions::UnauthorizedError, :with => :unauthorized
  
  include SessionsHelper
  include ReputationHelper
  
  before_filter :authorize
  before_filter :set_locale
  before_filter :mark_notification_as_read

  delegate :allow?, to: :current_permission
  helper_method :allow?

  delegate :allow_param?, to: :current_permission
  helper_method :allow_param?  
  
  
  # Setea el idioma del usuario
  # Lo saca del parametro locale o el header HTTP_ACCEPT_LANGUAGE
  # si el locale no está seteado
  def set_locale
    logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
    I18n.locale = params[:locale] || extract_locale_from_accept_language_header
    logger.debug "* Locale set to '#{I18n.locale}'"
    Rails.application.routes.default_url_options[:locale]= I18n.locale 
  end
  
  def check_params?(required, index='')
    return true if required.blank?
    return false if params.blank? 
    required.each do | param |
      if index.blank?
        return false if params[param].blank? 
      else
        return false if params[index][param].blank? 
      end
    end
    true
  end
  
  
  private
    def extract_locale_from_accept_language_header
      if request.env['HTTP_ACCEPT_LANGUAGE'] == nil
        I18n.default_locale
      else
        request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
      end
      
    end
    
    # REQUEST ERRORS
    def bad_request (exception)    
      @message = exception.message
      respond_to do |f|
        f.json { render 'shared/error', layout: false, status: 400 }
        f.js { render 'shared/error', layout: false, status: 400 }
        f.html do
          flash[:error] = @message 
          redirect_to root_url
        end
      end
      return
    end
  
    def forbidden (exception)   
      @message = exception.message
      respond_to do |f|
        f.json { render 'shared/error', layout: false, status: 401 }
        f.js { render 'shared/error', layout: false, status: 401 }
        f.html do
          flash[:error] = @message 
          redirect_to root_url
        end
      end
      return  
    end
  
    def unauthorized (exception)   
      @message = exception.message
      respond_to do |f|
        f.json { render 'shared/error', layout: false, status: 403 }
        f.js { render 'shared/error', layout: false, status: 403 }
        f.html do
          flash[:error] = @message 
          redirect_to root_url
        end
      end
      return   
    end
    
    def mark_notification_as_read
      return if params[:notification_id].blank? or !signed_in?
      n = Notification.find(params[:notification_id])
      n.mark_as_read(current_user)
    end
    
    
    def current_permission
      @current_permission ||= Permission.new(current_user)
    end

    def current_resource
      nil
    end

    def authorize
      if current_permission.allow?(params[:controller], params[:action], current_resource)
        current_permission.permit_params! params
      else
        raise(RequestExceptions::UnauthorizedError.new(t(:please_sign_in))) unless signed_in?
        raise(RequestExceptions::UnauthorizedError.new(t(:no_permission_or_reputation)))
      end
    end
end
