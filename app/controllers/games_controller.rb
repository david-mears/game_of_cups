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
    @game.slug = set_slug
    @game.save
    redirect_to game_path(slug: @game.slug)
  end

  def show
    @game = Game.find_by(slug: slug_param) or return redirect_to games_not_found_path(slug: slug_param)
    set_player
  end

  def change_team
    @game = Game.find_by(slug: slug_param) or not_found
    session[:allegiance] = session[:allegiance] == 'good' ? 'evil' : 'good'
    redirect_to game_path(slug: @game.slug)
  end

  def games_not_found
    @slug = slug_param
  end

  private

  def game_params
    params.require(:game).permit(:number_of_players, :slug)
  end

  def set_slug
    begin
      slug = WordsApi.new.get_word(min_letters: 4, max_letters: 4)
    rescue SocketError => error
      slug = ('a'..'z').to_a.shuffle[0..3].join()
    end
    slug = set_slug if slug == 'find'
    return slug
  end

  def set_player
    if session[:player_id].blank?
      redirect_to new_game_player_path(game_slug: slug_param)
    else
      @player = Player.find(session[:player_id])
    end
  end

  def slug_param
    params.permit(:slug)[:slug].downcase
  end
end
