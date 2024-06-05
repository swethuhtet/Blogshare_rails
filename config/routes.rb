Rails.application.routes.draw do
  
  root 'blogs#index'

  get 'categories/index'
  get 'blogs/index'
  get 'blogs/show'
  get 'blogs/create'
  
  resources :blogs do 
    resources :categories, only: [:index]
  end

  devise_for :users, 
  path:'',
  path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    registrations: 'registrations', 
    sessions: 'sessions' 
  }

  get '/profile', to: 'users#profile'
  get '/users', to: 'users#index'
  patch '/users/:id', to: 'users#update'
  get '/users/:id', to: 'users#show'
  delete '/users/:id', to: 'users#destroy'
  patch '/users/:id/update_password', to: 'users#update_password'
  post '/forgot_password', to: 'users#forgot_password'
  post '/reset_password', to: 'users#reset_password'
end
