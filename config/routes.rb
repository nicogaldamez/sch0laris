Sch0larisRepo::Application.routes.draw do
  
  resources :sessions, only: [:create, :destroy]
  resources :tags, only: [:index]
  resources :comments, only: [:destroy]
  resources :notifications, only: [:index]

  resources :questions do
    resources :comments, only: [:new, :create]
    resources :votes, only: [] do
      collection do
        get 'up'
        get 'down'
      end
    end
    
    collection do
      get 'pre_ask'
    end
  end
  
  
  resources :answers, only: [:create, :destroy] do
    resources :comments, only: [:new, :create]
    resources :votes, only: [] do
      collection do
        get 'up'
        get 'down'
      end
    end
    member do
      post 'best_answer'
    end
  end

  resources :users do
    member do
      get 'feed'
      put 'crop_avatar'
      put 'upload_avatar'
    end
  end
  
  root to: 'questions#index'

  match '/signout', to: 'sessions#destroy', via: :delete
  match '/ask', to: 'questions#ask'
  match '/list_questions', to: 'questions#questions'
  match '/list_entries', to: 'questions#entries'
  match '/profile/personal', to: 'users#personal_profile'
  match '/profile/password', to: 'users#password_profile'
  match '/profile/avatar', to: 'users#avatar_profile'
  
end
