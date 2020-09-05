require 'rails_helper'

RSpec.feature 'End-to-end test' do
  before { allow_any_instance_of(Object).to receive(:rand).and_return(12_345) }

  scenario 'can create and view a game' do
    visit root_path
    click_on 'Make new game'
    fill_in 'game_number_of_players', with: 5
    click_on 'Begin'
    expect(page).to have_content('You are viewing the game called 12345')
    expect(page).to have_content('Slug: 12345')
    expect(Game.find_by(slug: 12345).number_of_players).to eq 5
    expect(page).to have_content("Cups:\nThe Accursed Chalice\nMerlin's Goblet\nThe Holy Grail")
    visit root_path
    fill_in 'game_slug', with: '12345'
    click_on 'Next'
    expect(page).to have_content('You are viewing the game called 12345')
  end
end
