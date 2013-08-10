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
      else
        vote = vote.first
        raise(RequestExceptions::BadRequestError.new(t(:already_voted))) unless vote.value != value
        vote.destroy
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
      resource, id = request.path.split('/')[1,2]
      @voteable = resource.singularize.classify.constantize.find(id)
    end
end
