require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:player) { Player.create(name: 'Bill') }

  it 'has a default allegiance of good' do
    expect(player).to be_good
  end
end
