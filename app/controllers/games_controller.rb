class GamesController < ApplicationController
  before_action :set_no_leave_game, only: %w[index]
  before_action :set_game, except: %w[index find new create game_not_found]
  before_action :check_game_status, only: %w[show]
  before_action :check_if_game_is_full, only: %w[show]
  before_action :check_if_session_player_belongs_to_game, only: %w[show]
  before_action :check_session_player_presence, only: %w[show]
  before_action :set_allegiance_symbol, only: %w[show]

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
    @game.slug = Game.generate_slug
    @game.save
    if session_player.present?
      redirect_to game_path(slug: @game.slug)
    else
      redirect_to new_game_player_path(game_slug: @game.slug)
    end
  end

  def show
    @player = session_player
    unless @game.quorate? && !@game.draft?
      @url = request.original_url
      @ready_to_start = !@game.quorate? || @game.started?
      render 'lobby' and return
    end

    @draughts = @game.players.map(&:draughts).flatten
  end

  def start
    return unless @game.quorate?
    return unless @game.draft?

    @game.start
  end

  def game_not_found
    @slug = slug_param
  end

  def game_trashed; end

  def leave_game
    @game.players.destroy(session_player) unless session_player.blank? || @game.blank?
    @game&.trashed! if @game&.players&.empty?
    session.destroy
    redirect_to root_path
  end

  private

  def game_params
    params.require(:game).permit(:number_of_players, :slug, :number_of_evil_players_at_start)
  end

  def slug_param
    (params.permit(:slug)[:slug] || params.permit(:game_slug)[:game_slug])&.downcase
  end

  def check_game_status
    return redirect_to game_trashed_path(slug: slug_param) if @game.trashed?
  end

  def check_if_game_is_full
    return if @game.players.include? session_player
    return if @game.players.count < @game.number_of_players

    redirect_to root_path, alert: "Sorry, the game ‘#{@game.slug}’ is full."
  end

  def check_if_session_player_belongs_to_game
    return if @game.players.include? session_player

    session_player&.destroy
    session.destroy
  end

  def check_session_player_presence
    redirect_to new_game_player_path(game_slug: slug_param) if session[:player_id].blank? || session_player.blank?
  end

  def set_allegiance_symbol
    @allegiance_symbol = session_player&.allegiance == 'good' ? '♱' : '𖤐'
  end
end
