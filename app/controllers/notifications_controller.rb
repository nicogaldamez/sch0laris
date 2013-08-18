class NotificationsController < ApplicationController
  
  def index
    @notifications = current_user.mailbox.notifications.not_trashed.page(params[:page]).per_page(10)
    
    render 'index', layout: false
  end
end
