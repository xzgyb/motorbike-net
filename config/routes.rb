Rails.application.routes.draw do
  use_doorkeeper do
    controllers applications: 'oauth/applications', authorized_applications: 'oauth/authorized_applications'
  end

  devise_for :users

  get '/bike_info/:id', to: 'bike_info#show', as: 'bike_info'

  resources :bikes, only: :index
  resources :users, only: [:index, :update, :destroy]
  resources :topics do
    resources :posts
  end

  mount Api::Dispatch => '/'

  root 'home#index'
  match '*path', via: :all, to: redirect('/')
end
