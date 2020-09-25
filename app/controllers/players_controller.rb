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
    redirect_to game_path(slug: slug_param), alert: @game.players.one? ? 'Great! Now reload the page.' : nil
  end

  def quaff
    return unless @game.started?

    session_player.quaff Cup.find(cup_params[:cup_id])
    redirect_to game_path(slug: @game.slug)
  end

  private

  def cup_params
    params.permit(:cup_id)
  end

  def player_params
    params.require(:player).permit(:name)
  end

  def slug_param
    params.permit(:game_slug)[:game_slug].downcase
  end
end
