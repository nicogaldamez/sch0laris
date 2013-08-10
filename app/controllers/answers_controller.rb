class AnswersController < ApplicationController
  before_filter :signed_in_user, only: [:create, :vote]
  before_filter :belongs_to_user, only: [:destroy]
  
  def create
    raise(RequestExceptions::BadRequestError.new(t(:missing_params))) unless check_params?(['body','question_id'], :answer)
    
    @answer = Answer.new(params[:answer])
    @answer.user_id = current_user.id
    if !@answer.save
      raise(RequestExceptions::BadRequestError.new(@answer.errors.full_messages))
    end
    @answer = Question.find(@answer.question_id).answers.last
    render :partial => "answers/answer", :locals => { :answer => @answer }, :layout => false
  end
  
  def show
    @answer = Answer.find(params[:id])
  end
  
  def destroy
    if !@answer.destroy
      raise(RequestExceptions::BadRequestError.new(@answer.errors.full_messages))
    else
      render 'shared/success'
    end
  end

  private
    def belongs_to_user
      @answer = Answer.find(params[:id])
      raise(RequestExceptions::ForbiddenError.new(t(:no_permission))) unless @answer.user == current_user    
    end

end
