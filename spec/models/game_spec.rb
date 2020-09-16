require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { Game.create(slug: 'test', number_of_players: 4) }

  it 'has a default status of draft which can be overridden' do
    expect(game).to be_draft
    expect(Game.create(slug: 'test', number_of_players: 4, status: 'started')).to be_started
  end
end
