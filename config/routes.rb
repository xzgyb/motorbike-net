Rails.application.routes.draw do
  use_doorkeeper do
    controllers applications: 'oauth/applications', authorized_applications: 'oauth/authorized_applications'
  end

  devise_for :users, controllers: {
      sessions: :sessions,
      registrations: :registrations
  }

  get '/bikes/all', to: 'bikes#all', as: 'bikes'

  resources :users, only: [:index, :update, :destroy] do
    resources :bikes, only: [:index, :show]
  end

  resources :topics do
    resources :posts
  end
  resources :app_versions, only: [:index, :new, :create, :destroy]

  mount Api::Dispatch => '/'

  root 'home#index'
  get  '/doc', to: 'home#doc'
  put  '/medias/upload' 
  get  '/medias/index', as: 'medias'

  match '*path', via: :all, to: redirect('/')
end
