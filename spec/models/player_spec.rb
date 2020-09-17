require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:game) { Game.new(slug: 'game', number_of_players: 3) }
  let(:player) { Player.new(name: 'Bill', game: game) }
  let(:cup) { instance_double(Cup) }

  it 'has a default allegiance of good' do
    expect(player).to be_good
  end

  context 'when good' do
    context 'when drinking the Accursed Chalice' do
      before do
        allow(cup).to receive(:kind).and_return('accursed_chalice')
        player.drink(cup)
      end

      it 'becomes evil' do
        expect(player).to be_evil
      end
    end

    context "when drinking Merlin's Goblet" do
      before do
        allow(cup).to receive(:kind).and_return('merlins_goblet')
        player.drink(cup)
      end

      it 'remains good' do
        expect(player).to be_good
      end
    end
  end

  context 'when evil' do
    let(:player) { Player.new(name: 'Sauron', game: game, allegiance: 'evil') }

    context 'when drinking the Accursed Chalice' do
      before do
        allow(cup).to receive(:kind).and_return('accursed_chalice')
        player.drink(cup)
      end

      it 'remains evil' do
        expect(player).to be_evil
      end
    end

    context "when drinking Merlin's Goblet" do
      before do
        allow(cup).to receive(:kind).and_return('merlins_goblet')
        player.drink(cup)
      end

      it 'becomes good' do
        expect(player).to be_good
      end
    end
  end
end
