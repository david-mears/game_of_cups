Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'games#index'

  get '/games/(/:slug)/not_found', to: 'games#games_not_found', as: 'games_not_found'
  post '/games/find', to: 'games#find'
  post '/games/(/:slug)/start', to: 'games#start', as: 'start_game'
  resources :games, only: %i[create new show], param: :slug do
    resources :players, only: %i[create new]
  end

  post '/games/leave_game', to: 'games#leave_game'
  post '/games/(/:slug)', to: 'games#change_team'

end
