# == Schema Information
#
# Table name: question_views
#
#  id          :integer          not null, primary key
#  question_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class QuestionView < ActiveRecord::Base
end
