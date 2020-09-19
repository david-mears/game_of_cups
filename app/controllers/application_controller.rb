class ApplicationController < ActionController::Base
  def session_player
    Player.find_by(id: session[:player_id])
  end

  def set_game
    @game = Game.find_by(slug: slug_param) or return redirect_to game_not_found_path(slug: slug_param)
  end
end
