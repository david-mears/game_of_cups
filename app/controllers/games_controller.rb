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
    @game.slug = WordsApi.new.get_word(min_letters: 4, max_letters: 4)
    @game.save
    redirect_to game_path(slug: @game.slug)
  end

  def show
    @slug = params.permit(:slug)[:slug].downcase
    @game = Game.find_by(slug: @slug) or render 'game_not_found'
  end

  def change_team
    @game = Game.find_by(slug: params.permit(:slug)[:slug]) or not_found
    session[:allegiance] = session[:allegiance] == 'good' ? 'evil' : 'good'
    redirect_to game_path(slug: @game.slug)
  end

  private

  def game_params
    params.require(:game).permit(:number_of_players, :slug)
  end
end
