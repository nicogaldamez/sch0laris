# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  body       :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  votes      :integer          default(0)
#

class Question < ActiveRecord::Base
  attr_accessible :body, :title, :user_id, :tag_tokens, :post_type
  attr_reader :tag_tokens
  
  belongs_to :user
  has_many :views, :class_name => "QuestionView", :foreign_key => "question_id"
  has_many :questions_tags
  has_many :tags, through: :questions_tags
  has_many :answers, dependent: :destroy
  has_many :user_votes, :class_name => "Vote", as: :voteable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  
  # SCOPES
  scope :only_questions, where(post_type: 'Q')  
  scope :only_entries, where(post_type: 'E')  
  
  def tag_tokens=(tokens)
    self.tag_ids = Tag.ids_from_tokens(tokens)
  end
  
end
