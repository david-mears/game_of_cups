require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:number_of_players) { 3 }
  let(:number_of_evil_players_at_start) { 1 }
  let(:game) do
    Game.create(slug: 'test',
                number_of_players: number_of_players,
                number_of_evil_players_at_start: number_of_evil_players_at_start)
  end

  describe '#create' do
    it 'runs a callback applying a default status of draft, which can be overridden' do
      expect(Game.create(slug: 'new game',
                         number_of_players: number_of_players)).to be_draft
      expect(Game.create(slug: 'started game',
                         number_of_players: number_of_players,
                         status: 'started')).to be_started
    end
  end

  describe '#quorate?' do
    before do
      (number_of_players - 1).times do |index|
        Player.create(name: "Player #{index + 1}", game: game)
      end
    end

    context 'when there are not the specified number of players' do
      it 'returns false' do
        expect(game).not_to be_quorate
      end
    end

    context 'when there is the specified number of players' do
      before { Player.create(name: 'Tardy Latecomer', game: game) }

      it 'returns true' do
        expect(game).to be_quorate
      end
    end
  end

  describe '#start' do
    let(:number_of_players) { 5 }
    let(:number_of_evil_players_at_start) { 3 }
    let(:players) { game.players }

    before do
      number_of_players.times do |index|
        Player.create(name: "Player #{index + 1}", game: game)
      end
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

    it 'makes three other players evil' do
      expect(players.select(&:evil?).size).to eq 3
    end

    it 'leaves any other players good' do
      expect(players.select(&:good?).size).to eq(number_of_players - number_of_evil_players_at_start)
    end
  end

  describe '#victorious_knights' do
    context 'when the game is not finished' do
      it 'returns an empty array' do
        expect(game.victorious_knights).to be_empty
      end
    end

    context 'when the game is finished' do
      let(:number_of_players) { 4 }

      before do
        number_of_players.times do |index|
          Player.create(name: "Player #{index + 1}", game: game)
        end
        game.players.first.update!(arthur: true, allegiance: 'evil')
        game.players.second.update!(allegiance: 'evil')
        game.players.last.update!(allegiance: 'evil')
        game.finished!
      end

      it 'returns the knights with the same allegiance as arthur' do
        expect(game.victorious_knights.map(&:name)).to eq(['Player 2', 'Player 4'])
      end
    end
  end
end
