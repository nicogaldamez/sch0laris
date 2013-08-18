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
#

class Answer < ActiveRecord::Base
  attr_accessible :body, :question_id, :created_at, :user, :user_id, :best_answer
  
  belongs_to :user
  belongs_to :question
  has_many :user_votes, class_name: 'Vote', as: :voteable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  
  after_commit :create_notification
  
  private
    def create_notification
      question = self.question
      return false if user == question.user
      type = (question.post_type == 'Q') ? 'question' : 'answer'
      subject = I18n.t('notification.answer.'+ type, 
           :sender => self.user.name,
           :whose => I18n.t('notification.whose.yours')
      )
      body = "#{self.body}"
      question.user.notify(subject, body, self)
    end
end
