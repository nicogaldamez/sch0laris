class NotificationsController < ApplicationController
  
  def index
    # Ultimas 10 notificaciones
    @notifications = current_user.mailbox.notifications.not_trashed.page(params[:page]).per_page(10)
    @notifications = @notifications.dup
    @unread_count = current_user.mailbox.notifications.unread.count(:id, :distinct => true)
    
    render 'index', layout: false
  end
  
  def check_new
    @unread_count = current_user.mailbox.notifications.unread.count(:id, :distinct => true).to_s
    respond_to do |f|
      f.json { render json: { unread_count: @unread_count } }
    end
  end
  
  def mark_all_as_read
    notifications = current_user.mailbox.notifications.all
    current_user.mark_as_read(notifications)
    
    redirect_to :back
  end
end
