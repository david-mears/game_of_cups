class PlayersController < ApplicationController
  before_action :set_game

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)
    @player.game = @game
    @player.save
    session[:player_id] = @player.id
    redirect_to game_path(slug: slug_param)
  end

  private

  def player_params
    params.require(:player).permit(:name)
  end

  def slug_param
    params.permit(:game_slug)[:game_slug].downcase
  end
end
