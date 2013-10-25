Sch0larisRepo::Application.routes.draw do
  
  resources :sessions, only: [:create, :destroy]
  resources :tags, only: [:index]
  resources :comments, only: [:destroy]
  resources :password_resets

  resources :notifications, only: [:index] do
    collection do
      get 'check_new'
      post 'mark_all_as_read'
    end
  end
  
  resources :questions do
    resources :comments, only: [:new, :create]
    resources :votes, only: [] do
      collection do
        get 'up'
        get 'down'
      end
    end
    member do
      get 'history'
    end
    collection do
      get 'pre_ask'
    end
  end
  
  
  resources :answers do
    resources :comments, only: [:new, :create]
    resources :votes, only: [] do
      collection do
        get 'up'
        get 'down'
      end
    end
    member do
      post 'best_answer'
      get 'history'
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
  match '/faq', to: 'static_pages#faq'
  match '/contact', to: 'static_pages#contact'
  match '/terms', to: 'static_pages#terms'
  match '/list_questions', to: 'questions#questions'
  match '/list_entries', to: 'questions#entries'
  match '/profile/personal', to: 'users#personal_profile'
  match '/profile/password', to: 'users#password_profile'
  match '/profile/avatar', to: 'users#avatar_profile'
  match '/profile/delete', to: 'users#confirm_delete'
  
  
  # Sign in with twitter
  match 'auth/:provider/callback', to: 'sessions#social_network_callback'
  match 'auth/failure', to: redirect('/')
end
