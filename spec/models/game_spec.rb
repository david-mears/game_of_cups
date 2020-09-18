require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:number_of_players) { 3 }
  let(:game) { Game.create(slug: 'test', number_of_players: number_of_players) }

  it 'has a default status of draft which can be overridden' do
    expect(game).to be_draft
    expect(Game.create(slug: 'test',
                       number_of_players: number_of_players,
                       status: 'started')).to be_started
  end

  describe '#quorate?' do
    context 'when there are not the specified number of players' do
      before { (number_of_players - 1).times { Player.create(game: game) } }

      it 'returns false' do
        expect(game).not_to be_quorate
      end
    end

    context 'when there is the specified number of players' do
      before { number_of_players.times { Player.create(game: game) } }

      it 'returns true' do
        expect(game).to be_quorate
      end
    end
  end

  describe '#start' do
    let(:number_of_players) { 5 }
    let(:players) { game.players }

    before do
      number_of_players.times { Player.create(game: game) }
      game.start
    end

    it 'sets the game status to started' do
      expect(game).to be_started
    end

    it 'assigns one player to be arthur' do
      expect(players.select(&:arthur?).size).to eq 1
    end

    it 'gives arthur an allegiance of good' do
      expect(players.select(&:arthur?).first).to be_good
    end

    it 'makes one other player evil' do
      expect(players.select(&:evil?).size).to eq 1
    end

    it 'leaves any other players good' do
      expect(players.select(&:good?).size).to eq number_of_players - 1
    end
  end
end
