class VotesController < ApplicationController
  before_filter :load_voteable
  before_filter :signed_in_user
  
  def vote(value)
    raise(RequestExceptions::BadRequestError.new(t(:own_vote))) unless @voteable.user != current_user
    ActiveRecord::Base.transaction do
      
      # Registro el voto si no votó antes
      # Si antes votó positivo y ahora negativo o 
      # viceversa anulo el voto
      vote = @voteable.user_votes.where(user_id: current_user.id)
      if vote.empty?
        @voteable.user_votes.create(user_id: current_user.id, value: value)
        
        # Aumento / Reduzco la reputación del usuario
        if @voteable.is_a?(Question)
          points = (value == 1) ? Reputation::POINTS_QUESTION_IS_VOTED_UP : Reputation::POINTS_QUESTION_IS_VOTED_DOWN
        else
          points = (value == 1) ? Reputation::POINTS_ANSWER_IS_VOTED_UP : Reputation::POINTS_ANSWER_IS_VOTED_DOWN
        end
        new_reputation(@voteable.user, points)
        new_reputation(current_user, Reputation::POINTS_VOTE_DOWN)
      else
        vote = vote.first
        raise(RequestExceptions::BadRequestError.new(t(:already_voted))) unless vote.value != value
        vote.destroy
        
        # Aumento / Reduzco la reputación del usuario
        if @voteable.is_a?(Question)
          points = (value == 1) ? Reputation::POINTS_QUESTION_IS_VOTED_DOWN : Reputation::POINTS_QUESTION_IS_VOTED_UP
        else
          points = (value == 1) ? Reputation::POINTS_ANSWER_IS_VOTED_DOWN : Reputation::POINTS_ANSWER_IS_VOTED_UP
        end
        new_reputation(@voteable.user, points, true)
      end
  
      @voteable.votes = @voteable.votes + value
      if @voteable.save
        @message = t(:changes_saved)
        render 'shared/success'
      else
        raise(RequestExceptions::BadRequestError.new(answer.errors.full_messages))
      end
    end
  end
  
  def up
    vote(1)  
  end
  
  def down
    vote(-1)
  end
  
  private

    def load_voteable
      # resource, id = request.path.split('/')[1,2]
#       @voteable = resource.singularize.classify.constantize.find(id)
    end
    
    def current_resource
      resource, id = request.path.split('/')[1,2]
      @current_resource = @voteable = resource.singularize.classify.constantize.find(id)
      # @current_resource ||= @voteable 
    end
end
