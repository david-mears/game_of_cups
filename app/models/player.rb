class Player < ApplicationRecord
  belongs_to :game
  # TODO: belongs_to :user

  after_create :broadcast_new_player_name

  SYMBOLS = {
    good: '♱',
    evil: '𖤐',
    arthur: '♔'
  }.freeze

  enum allegiance: { evil: 0, good: 1 }, _suffix: :allegiance

  def allegiance_symbol
    SYMBOLS[allegiance&.to_sym]
  end

  def broadcast_new_player_name
    ActionCable.server.broadcast 'games', { message: "a new player #{name} joined!" }
  end
end
