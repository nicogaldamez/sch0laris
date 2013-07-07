class QuestionsController < ApplicationController
  
  def index
  end
  
  def pre_ask
  end
  
  def ask
    @question = Question.new
  end
  
  def create
    raise(RequestExceptions::BadRequestError.new(t(:missing_params))) unless check_params?(['title','body'],:question)
    
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
