class Player < ApplicationRecord
  belongs_to :game
  # TODO: belongs_to :user

  SYMBOLS = {
    good: '♱',
    evil: '𖤐'
  }.freeze

  enum allegiance: { evil: 0, good: 1 }, _suffix: :allegiance

  def allegiance_symbol
    SYMBOLS[allegiance.to_sym]
  end
end
