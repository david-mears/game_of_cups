Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'games#index'

  get '/games/(/:slug)/not_found', to: 'games#game_not_found', as: 'game_not_found'
  post '/games/find', to: 'games#find'
  post '/games/(/:slug)/start', to: 'games#start', as: 'start_game'
  get '/games/(/:slug)/trashed', to: 'games#game_trashed', as: 'game_trashed'
  resources :games, only: %i[create new show], param: :slug do
    post '/change', to: 'games#change_team', as: 'change_team'
    resources :players, only: %i[create new]
  end

  post '/games/leave_game', to: 'games#leave_game'
end
