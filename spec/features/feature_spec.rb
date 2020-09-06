require 'rails_helper'

RSpec.feature 'End-to-end test' do
  before { allow_any_instance_of(WordsApi).to receive(:get_word).and_return('test') }

  scenario 'can create and view a game' do
    visit root_path
    click_on 'Make new game'
    fill_in 'game_number_of_players', with: 5
    click_on 'Begin'
    fill_in 'player_name', with: 'Mr Bean'
    click_on 'Create Player'
    expect(page).to have_content('Player: Mr Bean')
    expect(current_path).to match(/test/)
    expect(Game.find_by(slug: 'test').number_of_players).to eq 5
    expect(page).to have_content("Cups:\nThe Accursed Chalice\nMerlin's Goblet\nThe Holy Grail")
    visit root_path
    fill_in 'game_slug', with: 'test'
    click_on 'Next'
    expect(current_path).to match(/test/)
  end

  scenario 'game not found' do
    visit root_path
    fill_in 'game_slug', with: 'sausages'
    click_on 'Next'
    expect(page).to have_content("No game called sausages was found.")
  end
end
