class Answer < ActiveRecord::Base
  attr_accessible :body, :question_id, :created_at, :user, :user_id
  
  belongs_to :user
end
