Sch0larisRepo::Application.routes.draw do
  
  resources :users
  
  resources :sessions, only: [:create, :destroy]
  resources :tags, only: [:index]
  
  resources :questions do
    collection do
      get 'pre_ask'
    end
  end
  
  root to: 'static_pages#home'
  
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/ask', to: 'questions#ask'
end
