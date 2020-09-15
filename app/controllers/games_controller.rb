class GamesController < ApplicationController
  before_action :set_game, except: %w[index find new create game_not_found]
  before_action :check_game_status, only: %w[show]
  before_action :check_session_player, only: %w[show]

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
    @game.slug = generate_slug
    @game.save
    redirect_to game_path(slug: @game.slug)
  end

  def show
    @player = session_player
    @url = request.original_url
    render 'lobby' and return unless @game.quorate? && @game.started?
  end

  def change_team
    session[:allegiance] = session[:allegiance] == 'good' ? 'evil' : 'good'
    redirect_to game_path(slug: @game.slug)
  end

  def start
    return unless @game.quorate?

    @game.started! unless @game.started?
    @game.save
    ActionCable.server.broadcast 'games', { message: 'The game started', event: 'game_started' }
    redirect_to game_path(slug: slug_param)
  end

  def game_not_found
    @slug = slug_param
  end

  def game_trashed; end

  def leave_game
    @game.players.delete(session_player)
    @game.trashed! if @game.players.empty?
    redirect_to root_path
  end

  private

  def game_params
    params.require(:game).permit(:number_of_players, :slug).merge(status: 'draft')
  end

  def slug_param
    params.permit(:slug)[:slug].downcase
  end

  def generate_slug
    begin
      slug = WordsApi.new.get_word(min_letters: 4, max_letters: 4)
    rescue SocketError
      slug = ('a'..'z').to_a.sample(4).join
    end
    slug = generate_slug if slug == 'find'
    slug
  end

  def set_game
    @game = Game.find_by(slug: slug_param) or return redirect_to game_not_found_path(slug: slug_param)
  end

  def check_game_status
    return redirect_to game_trashed_path(slug: slug_param) if @game.trashed?
  end

  def check_session_player
    redirect_to new_game_player_path(game_slug: slug_param) if session[:player_id].blank? || session_player.blank?
  end
end
