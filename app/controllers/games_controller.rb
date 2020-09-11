class GamesController < ApplicationController
  before_action :set_player, only: %w[show]
  before_action :set_game, only: %w[show change_team start]

  def index; end

  def find
    redirect_to game_path(slug: game_params[:slug]) if game_params[:slug]
  end

  def new
    @day_or_night = Time.zone.now.hour >= 17 && Time.zone.now.hour <= 7 ? 'night' : 'day'
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    @game.slug = set_slug
    @game.save
    redirect_to game_path(slug: @game.slug)
  end

  def show
    lobby(game: @game) unless @game.quorate? && @game.started?
  end

  def change_team
    session[:allegiance] = session[:allegiance] == 'good' ? 'evil' : 'good'
    redirect_to game_path(slug: @game.slug)
  end

  def start
    return unless @game.quorate?
    @game.status = 'started' unless @game.started?
    @game.save
    ActionCable.server.broadcast 'games', { message: 'The game started', event: 'game_started' }
    redirect_to game_path(slug: slug_param)
  end

  def games_not_found
    @slug = slug_param
  end

  def leave_game
    @game = Game.find_by(slug: slug_param) or games_not_found
    @game.players.delete(session_player)
    if @game.players.empty? then @game.destroy end
    redirect_to root_path
  end

  private

  def lobby(game:)
    @game = game
    @url = request.original_url
    render 'lobby'
  end

  def game_params
    params.require(:game).permit(:number_of_players, :slug).merge(status: 'draft')
  end

  def slug_param
    params.permit(:slug)[:slug].downcase
  end

  def set_slug
    begin
      slug = WordsApi.new.get_word(min_letters: 4, max_letters: 4)
    rescue SocketError
      slug = ('a'..'z').to_a.sample(4).join
    end
    slug = set_slug if slug == 'find'
    slug
  end

  def set_player
    if session[:player_id].blank?
      redirect_to new_game_player_path(game_slug: slug_param)
    else
      @player = session_player
      redirect_to new_game_player_path(game_slug: slug_param) if @player.blank?
    end
  end

  def set_game
    @game = Game.find_by(slug: slug_param) or return redirect_to games_not_found_path(slug: slug_param)
  end
end
