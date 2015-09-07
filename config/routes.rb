require 'api'

Rails.application.routes.draw do
  devise_for :users
  
  resources :bikes, only: :index
  resources :users, only: [:index, :update, :destroy]
  resources :topics do
    resources :posts
  end

  mount MotorbikeNet::API => '/'
  
  root 'home#index'
  match '*path', via: :all, to: redirect('/')
end
