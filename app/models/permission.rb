class Permission
  
  def initialize(user)
    # Visitante
    allow :questions, [:index, :show, :history]
    allow :sessions, [:new, :create, :destroy, :social_network_callback]
    allow :users, [:show, :new, :create]
    allow :answers, [:show, :history]
    allow :comments, [:show]
    allow :password_resets, [:new, :create, :edit, :update]
    allow :tags, [:index]
    allow :static_pages, [:faq]
    
    # Miembro
    if user
      allow :questions, [:ask, :pre_ask, :create] unless user.reputation < Reputation::REPUTATION_ASK
      
      allow :questions, [:destroy] do |question|
        question.user_id == user.id
      end
      
      # Si es moderador puede editar las preguntas y respuestas, sino debe ser dueño
      if user.reputation >= Reputation::REPUTATION_EDIT_QUESTIONS_AND_ANSWERS
        allow :questions, [:edit, :update]
        allow :answers, [:edit, :update]        
      else
        allow :questions, [:edit, :update] do |question|
          question.user_id == user.id
        end
        allow :answers, [:edit, :update] do |answer|
          answer.user_id == user.id
        end
      end
      
      
      allow :answers, [:create] unless user.reputation < Reputation::REPUTATION_ANSWER
      allow :answers, [:destroy] do |answer|
        answer.user_id == user.id
      end
      
      allow :answers, [:best_answer] do |answer|
        answer.question.post_type == 'Q' and answer.question.user_id == user.id
      end
      
      allow :votes, [:up] unless user.reputation < Reputation::REPUTATION_VOTE_UP
      allow :votes, [:down] do |voteable|
        if voteable.user_votes.where(user_id: user.id, value: 1).size() > 0
          true
        else
          if (user.reputation < Reputation::REPUTATION_VOTE_DOWN)
            false
          else
            true
          end
        end
      end
      allow :tags, [:create] unless user.reputation < Reputation::REPUTATION_CREATE_TAGS
      allow :comments, [:new, :create, :destroy] unless user.reputation < Reputation::REPUTATION_COMMENT
      allow :tags, [:index]
      allow :notifications, [:check_new, :index]
      allow :users, [:personal_profile, :password_profile, :avatar_profile, :update, :upload_avatar, :crop_avatar,
                     :confirm_delete, :destroy]
    end
  end
  
  def allow?(controller, action, resource = nil)
    allowed = @allow_all || @allowed_actions[[controller.to_s, action.to_s]]
    allowed && (allowed == true || resource && allowed.call(resource))
    
  end
  
  def allow_all
    @allow_all = true
  end
  
  def allow(controllers, actions, &block)
    @allowed_actions ||= {}
    Array(controllers).each do |controller|
      Array(actions).each do |action|
        @allowed_actions[[controller.to_s, action.to_s]] = block || true
      end
    end
  end

  def allow_param(resources, attributes)
    @allowed_params ||= {}
    Array(resources).each do |resource|
      @allowed_params[resource] ||= []
      @allowed_params[resource] += Array(attributes)
    end
  end

  def allow_param?(resource, attribute)
    if @allow_all
      true
    elsif @allowed_params && @allowed_params[resource]
      @allowed_params[resource].include? attribute
    end
  end

  def permit_params!(params)
    if @allow_all
      params.permit!
    elsif @allowed_params
      @allowed_params.each do |resource, attributes|
        if params[resource].respond_to? :permit
          params[resource] = params[resource].permit(*attributes)
        end
      end
    end
  end
end