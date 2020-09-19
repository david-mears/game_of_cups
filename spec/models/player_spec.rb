require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:game) { Game.create(slug: 'game', number_of_players: 3) }
  let(:player) { Player.new(name: 'Bill', game: game) }
  let(:players) { [] }
  let(:cup) { instance_double(Cup) }

  before do
    allow(cup).to receive(:players).and_return(players)
  end

  it 'has a default allegiance of good' do
    expect(player).to be_good
  end

  describe '#quaffed?' do
    context 'when the player is unassociated to the cup' do
      it 'is false' do
        expect(player.quaffed?(cup)).to eq false
      end
    end

    context 'when the player is associated to the cup' do
      let(:players) { [player] }

      it 'is true' do
        expect(player.quaffed?(cup)).to eq true
      end
    end
  end

  describe '#quaff' do
    context 'when drinking any cup' do
      before do
        allow(cup).to receive(:accursed_chalice?).and_return(true)
        player.quaff(cup)
      end

      it 'creates an association between the cup and the player' do
        expect(player.quaffed?(cup)).to eq true
      end
    end

    context 'when good' do
      it 'can display a symbol of good' do
        expect(player.allegiance_symbol).to eq '♱'
      end

      context 'when quaffing the Accursed Chalice' do
        before do
          allow(cup).to receive(:accursed_chalice?).and_return(true)
          player.quaff(cup)
        end

        it 'becomes evil' do
          expect(player).to be_evil
        end
      end

      context "when quaffing Merlin's Goblet" do
        before do
          allow(cup).to receive(:accursed_chalice?).and_return(false)
          allow(cup).to receive(:merlins_goblet?).and_return(true)
          player.quaff(cup)
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

      context 'when quaffing the Accursed Chalice' do
        before do
          allow(cup).to receive(:accursed_chalice?).and_return(true)
          player.quaff(cup)
        end

        it 'remains evil' do
          expect(player).to be_evil
        end
      end

      context "when quaffing Merlin's Goblet" do
        before do
          allow(cup).to receive(:accursed_chalice?).and_return(false)
          allow(cup).to receive(:merlins_goblet?).and_return(true)
          player.quaff(cup)
        end

        it 'becomes good' do
          expect(player).to be_good
        end
      end
    end

    context 'when Arthur' do
      let(:player) { Player.new(name: 'Bill', game: game, arthur: true) }

      context 'when quaffing the Holy Grail' do
        before do
          allow(cup).to receive(:accursed_chalice?).and_return(false)
          allow(cup).to receive(:merlins_goblet?).and_return(false)
          allow(cup).to receive(:holy_grail?).and_return(true)
        end

        it 'ends the game' do
          expect(game).to receive(:finished!)
          player.quaff(cup)
        end
      end
    end
  end
end
