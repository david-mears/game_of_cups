class PlayersController < ApplicationController
  before_action :set_game
  before_action :check_if_game_is_full

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

  def game_slug_param
    params.permit(:game_slug)[:game_slug].downcase
  end

  def set_game
    @game = Game.find_by(slug: game_slug_param) or return redirect_to games_not_found_path(slug: game_slug_param)
  end

  def check_if_game_is_full
    return if @game.players.include? session_player
    if @game.players.count >= @game.number_of_players
      redirect_to root_path, alert: "Sorry, the game '#{@game.slug}' is full."
    end
  end
end
