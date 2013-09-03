module NotificationsHelper

  # An activity object title
  def title_of(act_obj)
    if act_obj.respond_to? :body and (not act_obj.body.nil?)
      act_obj.body.truncate(30, :separator => ' ')
    else
      I18n.t('notification.default')
    end
  end

  # Add notification_id param to URL in order to mark notification read
  def notification_url_of(target, notification)
    if target.is_a? Answer
      notification_url_of(target.question, notification)
    elsif target.is_a? Comment
      notification_url_of(target.commentable, notification)
    else
      return polymorphic_url(target, :notification_id => notification.id) unless notification.nil?
      polymorphic_url(target)
    end
  end

end