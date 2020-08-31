class GamesController < ApplicationController
  def index; end

  def find
    redirect_to game_path(slug: game_params[:slug]) if game_params[:slug]
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    @game.save
    redirect_to game_path(slug: @game.slug)
  end

  def show
    @game = Game.find_by(slug: params.permit(:slug)[:slug]) or not_found
  end

  private

  def game_params
    params.require(:game).permit(:slug, :number_of_players)
  end
end