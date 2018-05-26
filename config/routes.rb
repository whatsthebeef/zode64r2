Rails.application.routes.draw do
  resources :thoughts do
    get :about_me, on: :collection
    get :work, on: :collection
  end
  root to: 'thoughts#index'
  get :thoughts, to: 'thoughts#index'
  get :about_me, to: 'thoughts#about_me'
  get :work, to: 'thoughts#work'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
end
