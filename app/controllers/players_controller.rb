class PlayersController < ApplicationController
  before_action :set_game, only: %w[create]

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)
    @player.game_id = @game.id
    @player.save
    session[:player_id] = @player.id
    redirect_to game_path(slug: game_slug_param)
  end

  private

  def player_params
    params.require(:player).permit(:name)
  end

  def set_game
    @game = Game.find_by(slug: game_slug_param)
  end

  def game_slug_param
    params.permit(:game_slug)[:game_slug].downcase
  end
end
