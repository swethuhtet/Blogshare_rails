Rails.application.routes.draw do
  devise_for :users
  get 'categories/index'
  get 'blogs/index'
  get 'blogs/show'
  get 'blogs/create'
  root 'blogs#index'
  resources :blogs do 
    resources :categories, only: [:index]
  end
end
