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
  has_paper_trail
  attr_accessible :body, :question_id, :created_at, :user, :user_id, :best_answer
  
  belongs_to :user
  belongs_to :question
  has_many :user_votes, class_name: 'Vote', as: :voteable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :notifications, dependent: :destroy, foreign_key: "notified_object_id",
        :conditions => proc { "notified_object_type = 'Answer'" }
  
  
  after_commit :create_notification, :on => :create
  
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
end
