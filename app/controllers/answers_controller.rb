class AnswersController < ApplicationController
  
  def create
    raise(RequestExceptions::BadRequestError.new(t(:missing_params))) unless check_params?(['body','question_id'], :answer)
    
    @answer = Answer.new(params[:answer])
    @answer.user_id = current_user.id
    if !@answer.save
      raise(RequestExceptions::BadRequestError.new(@answer.errors.full_messages))
    else
      @answer.create_activity :create, owner: current_user
    end
    @answer = Question.find(@answer.question_id).answers.last
  end
  
  def update
    raise(RequestExceptions::BadRequestError.new(t(:missing_params))) unless check_params?(['body','question_id'], :answer)
    
    @answer = Answer.find(params[:answer][:id])    
    @answer.user_id = current_user.id
    if !@answer.update_attributes(params[:answer])
      raise(RequestExceptions::BadRequestError.new(@answer.errors.full_messages))
    end
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
  
  def edit
  end
  
  def best_answer
    raise(RequestExceptions::BadRequestError.new(t(:own_answer))) unless @answer.user != current_user
    begin
      ActiveRecord::Base.transaction do
        was_best_answer = @answer.best_answer
        if !@answer.update_attributes(best_answer: (!@answer.best_answer))
          raise(RequestExceptions::BadRequestError.new(@answer.errors.full_messages))
        else
          # Sumo a la reputación del que escribió la respuesta seleccionada
          new_reputation(@answer.user, Reputation::POINTS_ANSWER_IS_MARKED_AS_ACCEPTED, was_best_answer)
          
          # Cancelo la respuesta que antes estaba marcada como la mejor
          old_best_answer = Answer.where("question_id = #{@answer.question_id} and id <> #{@answer.id} and best_answer")
          if !old_best_answer.blank?
            # Resto reputación porque se destilda una mejor respuesta anterior 
            new_reputation(current_user, Reputation::POINTS_MARK_ANSWER_AS_ACCEPTED, true)
            
            new_reputation(old_best_answer.first.user, Reputation::POINTS_ANSWER_IS_MARKED_AS_ACCEPTED, true)
            old_best_answer.first.update_attributes(best_answer: false)
          end 
          
          # Sumo / Resto reputación al que eligió la mejor respuesta
          new_reputation(current_user, Reputation::POINTS_MARK_ANSWER_AS_ACCEPTED, was_best_answer)
          
          render 'shared/success'
        end
      end
    end
  end
  
  def history
    @versions = @answer.versions
    render 'shared/history'
  end

  private
    def belongs_to_user
      @answer = Answer.find(params[:id])
      raise(RequestExceptions::ForbiddenError.new(t(:no_permission))) unless @answer.user == current_user    
    end
    
    def is_question_owner
      @answer = Answer.find(params[:id])
      question = Question.find(@answer.question_id)
      raise(RequestExceptions::ForbiddenError.new(t(:no_permission))) unless question.user == current_user    
    end
    
    def current_resource
      @answer = @current_resource ||= Answer.find(params[:id]) if params[:id]
    end

end
