class ApplicationController < ActionController::Base
  before_action :set_allegiance_class_and_symbol

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  def set_allegiance_class_and_symbol
    session[:allegiance] ||= 'good'
    @allegiance_symbol = session[:allegiance] == 'good' ? '♱' : '𖤐'
    @allegiance = session[:allegiance]
  end
end
