Sch0larisRepo::Application.routes.draw do
  
  resources :sessions, only: [:create, :destroy]
  resources :answers, only: [:create, :destroy, :show]
  resources :tags, only: [:index]

  resources :users do
    member do
      put 'crop_avatar'
      put 'upload_avatar'
    end
  end
  
  resources :questions do
    collection do
      get 'pre_ask'
    end
  end
  
  root to: 'questions#index'
  
  put 'approve_class_room/:id(.:format)', :to => 'class_room_member_ships#approve',
                                          :as => :approve_class_room
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/ask', to: 'questions#ask'
  match '/profile/personal', to: 'users#personal_profile'
  match '/profile/password', to: 'users#password_profile'
  match '/profile/avatar', to: 'users#avatar_profile'
end
