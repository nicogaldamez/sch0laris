Sch0larisRepo::Application.routes.draw do
  
  resources :users
  resources :questions
  resources :sessions, only: [:create, :destroy]
  
  root to: 'static_pages#home'
  
  match '/signout', to: 'sessions#destroy', via: :delete
end
