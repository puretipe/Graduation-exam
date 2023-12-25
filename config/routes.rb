Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  get 'password_resets/new'
  get 'password_resets/create'
  get 'password_resets/edit'
  get 'password_resets/update'
  get 'songs/index'
  get 'home/index'
  get 'login', to: 'user_sessions#new', as: :login
  get "up" => "rails/health#show", as: :rails_health_check

  root 'home#index'
  
  resources :users, only: [:new, :create]
  resource :user_session, only: [:new, :create, :destroy]
  resources :songs do
    resources :evaluations, only: [:create, :update, :destroy]
    resources :favorites, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
    collection do
      get 'my_songs'
      get :favorites
    end
  end
  resources :profiles, only: [:show, :edit, :update]
  resources :password_resets, only: [:new, :create, :edit, :update]

  get 'autocompletes/songs', to: 'autocompletes#autocomplete'
end
