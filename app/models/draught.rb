class Draught < ApplicationRecord
  belongs_to :player
  belongs_to :cup

  validate :cup_and_player_belong_to_same_game

  def cup_and_player_belong_to_same_game
    unless cup.game == player.game
      errors.add(:cup, 'must belong to same game as the player')
    end
  end
end
