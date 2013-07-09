class QuestionsController < ApplicationController
  
  def index
    @questions = Question.all
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
  end
end
