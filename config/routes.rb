Sch0larisRepo::Application.routes.draw do
  
  resources :users
  resources :sessions, only: [:create, :destroy]
  
  root to: 'static_pages#home'
end
