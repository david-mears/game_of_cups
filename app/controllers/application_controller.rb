class ApplicationController < ActionController::Base
  before_action :set_raven_context

  def session_player
    Player.find_by(id: session[:player_id])
  end

  def set_game
    return unless slug_param.present?

    @game = Game.find_by(slug: slug_param) or return redirect_to game_not_found_path(slug: slug_param)
  end

  private

  def set_raven_context
    Raven.user_context(id: session[:player_id])
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def set_no_leave_game
    @no_leave_game = true
  end
end
