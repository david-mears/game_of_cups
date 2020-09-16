class ApplicationController < ActionController::Base
  before_action :set_allegiance_class_and_symbol

  def set_allegiance_class_and_symbol
    session[:allegiance] ||= 'good'
    @allegiance_symbol = session[:allegiance] == 'good' ? '♱' : '𖤐'
    @allegiance = session[:allegiance]
  end

  def session_player
    Player.find_by(id: session[:player_id])
  end

  def set_game
    @game = Game.find_by(slug: slug_param) or return redirect_to game_not_found_path(slug: slug_param)
  end
end
