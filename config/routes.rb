Rails.application.routes.draw do
  root 'homepage#index'
  get '/feeds' => 'feeds#index'

  # USERS
  resources :users, only: [:create]
  # SESSIONS
  resources :sessions, only: [:create, :destroy]
  get '/authenticated', to: 'sessions#authenticated'
  # TWEETS
  resources :tweets, only: [:create, :destroy, :index]
  get '/users/:username/tweets', to: 'tweets#index_by_user'

  # Redirect all other paths to index page, which will be taken over by AngularJS
  get '*path' => 'homepage#index'
end
