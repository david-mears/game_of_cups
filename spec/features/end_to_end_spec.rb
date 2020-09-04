require 'rails_helper'

RSpec.feature 'End-to-end test' do
  scenario 'can create and view a game' do
    visit root_path
    click_on 'Make new game'
    fill_in 'game_number_of_players', with: 5
    fill_in 'game_slug', with: 'cup game test'
    click_on 'Begin'
    expect(page).to have_content('You are viewing the game called cup game test')
    expect(page).to have_content('Slug: cup game test')
    expect(page).to have_content('Players: 5')
    expect(page).to have_content("Cups:\nThe Accursed Chalice\nMerlin's Goblet\nThe Holy Grail")
    visit root_path
    fill_in 'game_slug', with: 'cup game test'
    click_on 'Next'
    expect(page).to have_content('You are viewing the game called cup game test')
  end
end
