class AnswersController < ApplicationController
  before_filter :signed_in_user, only: [:create]
  
  def create
    raise(RequestExceptions::BadRequestError.new(t(:missing_params))) unless check_params?(['body','question_id'], :answer)
    
    @answer = Answer.new(params[:answer])
    @answer.user_id = current_user.id
    if @answer.save
      redirect_to @answer, format: :json
    else
      raise(RequestExceptions::BadRequestError.new(@answer.errors.full_messages))
    end
  end
  
  def show
    @answer = Answer.find(params[:id])
  end
end
