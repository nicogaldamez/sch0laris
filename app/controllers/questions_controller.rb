class QuestionsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :ask, :pre_ask]
  
  def entries
    @questions = Question.only_entries
    @type = 'entries'
    render 'list'
  end
  
  def questions
    @questions = Question.only_questions
    @type = 'questions'
    render 'list'
  end
  
  def pre_ask
  end
  
  def ask
    @question = Question.new
  end
  
  def create
    raise(RequestExceptions::BadRequestError.new(t(:missing_params))) unless check_params?(['title','body','tag_tokens'],:question)
    # Se admiten de 2 a 5 tags
    tags_count = params[:question][:tag_tokens].split(',').length
    logger.debug tags_count
    if tags_count < 2  || tags_count > 5
      raise(RequestExceptions::BadRequestError.new(t("questions.ask.tags_error"))) 
    end
    
    params[:question][:user_id] = current_user.id
    @question = Question.new(params[:question])
    if @question.save
      redirect_to @question, format: :json
    else
      raise(RequestExceptions::BadRequestError.new(@question.errors.full_messages))
    end
    
  end
  
  def show
    @question = Question.find(params[:id])
    
    # Marco como vista por el usuario
    if signed_in? && @question.user != current_user
        view = @question.views.find_or_initialize_by_question_id_and_user_id(@question.id, current_user.id)
        view.save
    end
    
    @answer = @question.answers.new
  end
end
