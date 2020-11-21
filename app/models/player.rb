class Player < ApplicationRecord
  belongs_to :game
  has_many :draughts, dependent: :destroy
  has_many :cups, through: :draughts

  validates :name, presence: true
  validates :allegiance, presence: true
  validates :game_id, presence: true

  # TODO: belongs_to :user

  after_create :broadcast_new_player_name

  enum allegiance: { evil: 0, good: 1 }

  def allegiance_symbol
    SYMBOLS[allegiance&.to_sym]
  end

  def whether_arthur_symbol
    SYMBOLS[:arthur] if arthur?
  end

  def quaff(cup)
    cup.players << self
    if cup.accursed_chalice?
      evil!
    elsif cup.merlins_goblet?
      good!
    elsif arthur? && cup.holy_grail?
      game.finished!
    end
    broadcast_draught(cup)
  end

  def quaffed?(cup)
    cup.players.include? self
  end

  def broadcast_new_player_name
    GameChannel.broadcast_to(game, {
                               event: 'new_player',
                               name: name,
                               quorate: game.quorate?
                             })
  end

  private

  def broadcast_draught(cup)
    GameChannel.broadcast_to(game, {
                               event: 'cup_quaffed',
                               description: "#{name} drank cup #{cup.label}",
                               quaffer: id,
                             })
  end
end
