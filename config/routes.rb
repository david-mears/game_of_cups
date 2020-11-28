Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'games#index'

  get '/games/(/:slug)/not_found', to: 'games#game_not_found', as: 'game_not_found'
  post '/games/find', to: 'games#find'
  get '/games/leave_game', to: 'games#leave_game'
  post '/games/(/:slug)/start', to: 'games#start', as: 'start_game'
  get '/games/(/:slug)/trashed', to: 'games#game_trashed', as: 'game_trashed'
  resources :games, only: %i[create new show], param: :slug do
    resources :players, only: %i[create new] do
      post '/quaff', to: 'players#quaff'
    end
  end
end
