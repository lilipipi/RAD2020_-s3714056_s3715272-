Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'users/new'

  root 'static_pages#home'

  get  '/home',    to: 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get '/filtercontent',    to: 'static_pages#home'

  post '/home',    to: 'static_pages#filter'
  post '/filtercontent',    to: 'static_pages#filtercontent'

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  get '/microposts', to: 'microposts#new'
  post '/microposts', to: 'microposts#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/my_comments', to: 'users#my_comments'
  get '/my_posts', to: 'users#my_posts'
  get '/comments', to: 'users#comments'
  
  
  resources :users do
    resources :comments, module: :users
  end

  resources :microposts, only: [:create, :destroy, :show, :new]
  resources :microposts do
    resources :comments, module: :microposts
  end
  
  resources :comments
  resources :comments do
    resources :comments, module: :comments
  end


  resources :password_resets, only: [:new, :create, :edit, :update]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
