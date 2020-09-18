class Player < ApplicationRecord
  belongs_to :game
  # TODO: belongs_to :user

  after_create :broadcast_new_player_name

  SYMBOLS = {
    good: '♱',
    evil: '𖤐',
    arthur: '♔'
  }.freeze

  enum allegiance: { evil: 0, good: 1 }

  def allegiance_symbol
    SYMBOLS[allegiance&.to_sym]
  end

  def quaff(cup)
    if cup.accursed_chalice?
      evil!
    elsif cup.merlins_goblet?
      good!
    elsif arthur? && cup.holy_grail?
      game.finished!
    end
  end

  def broadcast_new_player_name
    ActionCable.server.broadcast 'games', {
      message: 'A new player joined',
      event: 'new_player',
      name: name,
      quorate: game.quorate?
    }
  end
end
