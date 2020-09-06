class ApplicationController < ActionController::Base
  before_action :set_allegiance_class_and_symbol

  def set_allegiance_class_and_symbol
    session[:allegiance] ||= 'good'
    @allegiance_symbol = session[:allegiance] == 'good' ? '♱' : '𖤐'
    @allegiance = session[:allegiance]
  end
end
