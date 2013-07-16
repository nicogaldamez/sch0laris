class Answer < ActiveRecord::Base
  attr_accessible :body, :question_id, :created_at, :user, :user_id
  
  belongs_to :user
  has_many :answer_votes, :class_name => "Vote", dependent: :destroy
end
