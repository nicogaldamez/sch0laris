Scholaris::Application.routes.draw do
  
  resources :users
  resources :questions
  resources :sessions, only: [:create, :destroy]
  
  root to: 'static_pages#home'
end
