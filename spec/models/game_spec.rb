require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { Game.create(slug: 'test', number_of_players: 3) }

  before do
    3.times { Player.create(game: game) }
  end

  it 'has a default status of draft which can be overridden' do
    expect(game).to be_draft
    expect(Game.create(slug: 'test', number_of_players: 3, status: 'started')).to be_started
  end

  describe '#start' do
    let(:players) { game.players }
    before { game.start }

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
  end
end
