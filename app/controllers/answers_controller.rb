class AnswersController < ApplicationController
  before_filter :signed_in_user, only: [:create, :vote]
  
  def create
    raise(RequestExceptions::BadRequestError.new(t(:missing_params))) unless check_params?(['body','question_id'], :answer)
    
    @answer = Answer.new(params[:answer])
    @answer.user_id = current_user.id
    if !@answer.save
      raise(RequestExceptions::BadRequestError.new(@answer.errors.full_messages))
    end
  end
  
  def show
    @answer = Answer.find(params[:id])
  end
  
  def vote
    answer = Answer.find(params[:id])
    value = (params[:type] == 'up') ? 1 : -1
    
    ActiveRecord::Base.transaction do
      # Registro el voto si no votó antes
      # Si antes votó positivo y ahora negativo o 
      # viceversa anulo el voto
      vote = answer.answer_votes.where(user_id: current_user.id)
      if vote.empty?
        answer.answer_votes.create(user_id: current_user.id, value: value)
      else
        vote = vote.first
        raise(RequestExceptions::BadRequestError.new(t(:already_voted))) unless vote.value != value
        vote.destroy
      end
    
      answer.votes = answer.votes + value
      if answer.save
        @message = t(:changes_saved)
        render 'shared/success'
      else
        raise(RequestExceptions::BadRequestError.new(answer.errors.full_messages))
      end
    end
  end
end
