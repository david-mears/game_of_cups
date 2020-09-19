require 'rails_helper'

RSpec.describe Draught, type: :model do
  let(:game) { Game.create(slug: 'game', number_of_players: 3) }
  let(:player) { Player.create(name: 'Bill', game: game) }
  let(:cup) do
    Cup.create(kind: :merlins_goblet,
               image: 'another cup.jpg',
               game: cup_game)
  end

  context 'when the player and the cup belong to the same game' do
    let(:cup_game) { game }

    it 'is not valid' do
      expect(Draught.new(player: player, cup: cup)).to be_valid
    end
  end

  context 'when the player and the cup belong to different games' do
    let(:cup_game) { Game.create(slug: 'game2', number_of_players: 3) }

    it 'is not valid' do
      expect(Draught.new(player: player, cup: cup)).not_to be_valid
    end
  end
end
