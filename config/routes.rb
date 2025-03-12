Rails.application.routes.draw do
  root 'homepage#index'
  get '/feeds' => 'feeds#index'

  # USERS
  resources :users, only: [:create]

  # SESSIONS
  post '/sessions', to: 'sessions#create'
  delete '/sessions', to: 'sessions#destroy'
  get '/authenticated', to: 'sessions#authenticated'

  # TWEETS
  resources :tweets, only: [:create, :index, :destroy]
  get '/users/:username/tweets', to: 'tweets#index_by_user'

  # Redirect all other paths to index page for AngularJS routing
  get '*path' => 'homepage#index'
end

