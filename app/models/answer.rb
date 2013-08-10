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
  attr_accessible :body, :question_id, :created_at, :user, :user_id
  
  belongs_to :user
  has_many :user_votes, class_name: 'Vote', as: :voteable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
end
