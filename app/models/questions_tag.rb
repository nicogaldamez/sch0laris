# == Schema Information
#
# Table name: questions_tags
#
#  id          :integer          not null, primary key
#  tag_id      :integer
#  question_id :integer
#

class QuestionsTag < ActiveRecord::Base
  # attr_accessible :tag_id, :question_id
  
  belongs_to :tag
  belongs_to :question
  
end
