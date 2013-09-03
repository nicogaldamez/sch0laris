# encoding: UTF-8
# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  body             :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  commentable_id   :integer
#  commentable_type :string(255)
#

class Comment < ActiveRecord::Base
  include PublicActivity::Common
  
  attr_accessible :body, :user_id
  
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :notifications, dependent: :destroy, foreign_key: "notified_object_id",
        :conditions => proc { "notified_object_type = 'Comment'" }
  
  after_commit :create_notification, on: :create
  
  private
    def create_notification
      obj = commentable
      if obj.is_a?(Answer)
        type = 'answer'
      else 
        type = (obj.post_type == 'Q') ? 'question' : 'entry'        
      end
      
      subject = "#{user.name} escribió el siguiente comentario"
      body = "#{self.body}"
      
      # Notifico al dueño de la pregunta
      subject = I18n.t('notification.commented' , 
           :sender => self.user.name,
           :whose => I18n.t('notification.whose.yours'),
           :thing => I18n.t("notification.thing.#{type}")
      )      
      obj.user.notify(subject, body, self) unless user == obj.user
      
      # Notifico al resto de los usuarios que participaron
      subject = I18n.t('notification.also_commented', 
            :sender => self.user.name,
            :thing => I18n.t("notification.thing.#{type}")
      )
      users_to_notify = User.uniq.joins(:comments).where(comments: {id: obj.comment_ids}).reject {|user| user == self.user || user == obj.user }
      users_to_notify.each do |u|
        u.notify(subject, body, self) 
      end
    end
end
