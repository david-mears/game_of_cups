require 'rails_helper'

RSpec.describe Game, type: :model do
  it 'can have a new blank game with no arthur' do
    expect(Game.new.has_arthur?).to eq false
  end

  context 'which is created with no arthur' do
    let(:game) { Game.create(slug: 'test', number_of_players: 4) }
    before { 3.times { Player.create(game: game) } }
    it 'returns false' do
      expect(game).to_not have_arthur
      expect(game).to be_valid
    end
  end

  context 'which is created with arthur' do
    let(:game) { Game.create(slug: 'test', number_of_players: 4) }
    before do
      3.times { Player.create(game: game) }
      Player.create(game: game, arthur: true)
    end

    it 'returns true' do
      Player.create(game: game, arthur: true)
      expect(game).to have_arthur
      expect(game).to be_valid
    end
  end
end
