require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:game) { Game.new(slug: 'game', number_of_players: 3) }
  let(:player) { Player.new(name: 'Bill', game: game) }
  let(:cup) { instance_double(Cup) }

  it 'has a default allegiance of good' do
    expect(player).to be_good
  end

  context 'when good' do
    it 'can display a symbol of good' do
      expect(player.allegiance_symbol).to eq '♱'
    end

    context 'when drinking the Accursed Chalice' do
      before do
        allow(cup).to receive(:accursed_chalice?).and_return(true)
        allow(cup).to receive(:merlins_goblet?).and_return(false)
        allow(cup).to receive(:holy_grail?).and_return(false)
        player.drink(cup)
      end

      it 'becomes evil' do
        expect(player).to be_evil
      end
    end

    context "when drinking Merlin's Goblet" do
      before do
        allow(cup).to receive(:accursed_chalice?).and_return(false)
        allow(cup).to receive(:merlins_goblet?).and_return(true)
        allow(cup).to receive(:holy_grail?).and_return(false)
        player.drink(cup)
      end

      it 'remains good' do
        expect(player).to be_good
      end
    end
  end

  context 'when evil' do
    let(:player) { Player.new(name: 'Sauron', game: game, allegiance: 'evil') }

    it 'can display a symbol of evil' do
      expect(player.allegiance_symbol).to eq '𖤐'
    end

    context 'when drinking the Accursed Chalice' do
      before do
        allow(cup).to receive(:accursed_chalice?).and_return(true)
        allow(cup).to receive(:merlins_goblet?).and_return(false)
        allow(cup).to receive(:holy_grail?).and_return(false)
        player.drink(cup)
      end

      it 'remains evil' do
        expect(player).to be_evil
      end
    end

    context "when drinking Merlin's Goblet" do
      before do
        allow(cup).to receive(:accursed_chalice?).and_return(false)
        allow(cup).to receive(:merlins_goblet?).and_return(true)
        allow(cup).to receive(:holy_grail?).and_return(false)
        player.drink(cup)
      end

      it 'becomes good' do
        expect(player).to be_good
      end
    end
  end

  context 'when Arthur' do
    let(:player) { Player.new(name: 'Bill', game: game, arthur: true) }

    context 'when drinking the Holy Grail' do
      before do
        allow(cup).to receive(:accursed_chalice?).and_return(false)
        allow(cup).to receive(:merlins_goblet?).and_return(false)
        allow(cup).to receive(:holy_grail?).and_return(true)
        player.drink(cup)
      end

      it 'ends the game' do
        expect(game).to be_finished
      end
    end
  end
end
