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
#  post_type  :string(1)        default("Q")
#

class Question < ActiveRecord::Base
  include PublicActivity::Common
  has_paper_trail :ignore => [:votes, :post_type]
  
  attr_accessible :body, :title, :user_id, :tag_tokens, :post_type
  attr_reader :tag_tokens
  
  belongs_to :user
  has_many :views, :class_name => "QuestionView", :foreign_key => "question_id"
  has_many :questions_tags
  has_many :tags, through: :questions_tags
  has_many :answers, dependent: :destroy
  has_many :user_votes, :class_name => "Vote", as: :voteable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :notifications, dependent: :destroy, foreign_key: "notified_object_id",
        :conditions => proc { "notified_object_type = 'Question'" }
  
  # SCOPES
  scope :only_questions, where(post_type: 'Q')  
  scope :only_entries, where(post_type: 'E')  
  
  include PgSearch
  pg_search_scope :search, against: [:title, :body],
    associated_against: {user: :name, answers: [:body]},
    :ignoring => :accents,
    :using => { :tsearch => {:prefix => true} }
  
  def tag_tokens=(tokens)
    self.tag_ids = Tag.ids_from_tokens(tokens)
  end
  
  def self.filter(type, filter, current_user)
    
    # Búsqueda
    if filter[:search].blank?
      result = where(true) # Todos
    else
      result = search(filter[:search])
    end
    
    # Tipo de post: pregunta o aporte
    if type == 'questions'
      result = result.where(post_type: 'Q') 
    else
      result = result.where(post_type: 'E') 
    end
    
    # Filtro u orden
    unless filter[:filter].blank?
      if filter[:filter] == 'most_recent'
        result = result.order("created_at DESC")
      elsif filter[:filter] == 'reputation'
        result = result.order("votes DESC")
      elsif filter[:filter] == 'my_school'
        result = result.joins("INNER JOIN users ON users.id = questions.user_id").where("users.school_id = ?", current_user.school_id).order("questions.created_at desc")
      end
    end
    
    # Filtro por tag
    unless filter[:tag].blank?
      result = result.joins("INNER JOIN questions_tags ON questions_tags.question_id = questions.id").where("questions_tags.tag_id = ?", filter[:tag])
    end
    
    result
  end

end
