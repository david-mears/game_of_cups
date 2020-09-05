class ApplicationController < ActionController::Base
  before_action :set_allegiance_class

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  def set_allegiance_class
    session[:allegiance] ||= 'good'
    @allegiance = session[:allegiance]
  end
end
