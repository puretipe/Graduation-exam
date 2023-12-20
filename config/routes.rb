Rails.application.routes.draw do
  get 'songs/index'
  get 'home/index'
  get "up" => "rails/health#show", as: :rails_health_check

  root 'home#index'
  
  resources :users, only: [:new, :create]
  resource :user_session, only: [:new, :create, :destroy]
  resources :songs do
    resources :evaluations, only: [:create, :update, :destroy]
    resources :favorites, only: [:create, :destroy]
    collection do
      get 'my_songs'
      get :favorites
    end
  end
  resources :profiles, only: [:show, :edit, :update]

  get 'autocompletes/songs', to: 'autocompletes#autocomplete'
end
