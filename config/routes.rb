Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'users/new'

  root 'static_pages#home'

  get  '/home',    to: 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  post '/home',    to: 'static_pages#filter'
  post '/filter',    to: 'static_pages#filter2'

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/microposts', to: 'static_pages#home'
  get '/my_comments', to: 'users#my_comments'
  
  
  resources :users do
    resources :comments, module: :users
  end
  resources :microposts, only: [:create, :destroy, :show, :new]
  resources :microposts do
    resources :comments, module: :microposts
  end
  resources :comments 
  resources :password_resets, only: [:new, :create, :edit, :update]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
