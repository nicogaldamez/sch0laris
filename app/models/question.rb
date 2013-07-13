# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  body       :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Question < ActiveRecord::Base
  attr_accessible :body, :title, :user_id, :tag_tokens
  attr_reader :tag_tokens
  
  belongs_to :user
  has_many :questions_tags
  has_many :tags, through: :questions_tags
  has_many :answers, dependent: :destroy
  
  def tag_tokens=(tokens)
    self.tag_ids = Tag.ids_from_tokens(tokens)
  end
  
end
