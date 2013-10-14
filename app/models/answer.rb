#encoding: UTF-8
# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  body        :text
#  user_id     :integer
#  question_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  votes       :integer          default(0)
#  best_answer :boolean
#

class Answer < ActiveRecord::Base
  include PublicActivity::Common
  has_paper_trail :ignore => [:votes, :best_answer]
  attr_accessible :body, :question_id, :created_at, :user, :user_id, :best_answer
  
  belongs_to :user
  belongs_to :question
  has_many :user_votes, class_name: 'Vote', as: :voteable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :notifications, dependent: :destroy, foreign_key: "notified_object_id",
        :conditions => proc { "notified_object_type = 'Answer'" }
  
  
  after_commit :create_notification, :on => :create
  after_commit :update_notification, :on => :update
  
  # Notifica al usuario de la respuesta que fue elegida como mejor respuesta
  def notify_best
    question_user = self.question.user
    body = self.body
    
    # Notifico al dueño de la pregunta
    subject = I18n.t('notification.best_answer', :sender => question_user.name)
    self.user.notify(subject, body, self)
  end
  
  # Notifica al usuario que la respuesta recibió un voto
  def notify_vote (up_vote)
    body = self.body
    
    up_or_down = (up_vote == 1) ? 'up' : 'down'
    subject = I18n.t('notification.voted', :thing => I18n.t("answers.answer.one"), 
      :up_or_down => I18n.t("notification.up_or_down.#{up_or_down}"))
      
    self.user.notify(subject, body, self)
  end
  
  private
    def create_notification
      question = self.question
      type = (question.post_type == 'Q') ? 'question' : 'entry'
      body = "#{self.body}"
      
      # Notifico al dueño de la pregunta
      subject = I18n.t('notification.answered' , 
           :sender => self.user.name,
           :whose => I18n.t('notification.whose.yours'),
           :thing => I18n.t("notification.thing.#{type}")
      )      
      question.user.notify(subject, body, self) unless user == question.user
      
      # Notifico al resto de los usuarios que participaron
      subject = I18n.t('notification.also_answered', 
            :sender => self.user.name,
            :thing => I18n.t("notification.thing.#{type}")
      )
      users_to_notify = User.uniq.joins(:answers).where(answers: {id: question.answer_ids}).reject {|user| user == self.user || user == question.user}
      users_to_notify.each do |u|
        u.notify(subject, body, self) 
      end
    end
    
    def update_notification
      modified_by = self.versions.last.terminator
      
      # Solo notifico si la modificación la hizo un moderador
      unless modified_by == self.user_id
        # Notifico al dueño de la respuesta que se realizó una modificación
        subject = I18n.t('notification.your_content_modified' , 
             :sender => User.find(modified_by).name,
             :thing => I18n.t("answers.answer.one")
        )      
        user.notify(subject, self.body, self)
      end
    end
end
