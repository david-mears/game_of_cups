require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.feature 'End-to-end test' do
  let(:game) { Game.find_by(slug: 'test') }
  let(:number_of_players) { 5 }
  before { allow_any_instance_of(WordsApi).to receive(:get_word).and_return('test') }

  scenario 'can create and view a game' do
    visit root_path
    click_on 'Make new game'
    fill_in 'game_number_of_players', with: number_of_players
    click_on 'Begin'
    fill_in 'player_name', with: 'Mr Bean'
    click_on 'Create Player'

    # Goes to lobby because not yet quorate
    expect(current_path).to match(/test/)
    expect(game.number_of_players).to eq number_of_players
    expect(page).to have_content('Lobby')
    expect(page).not_to have_content('Start') # Because we are not quorate
    expect(page).to have_content('/games/test') # Displays the url to share
    expect(page).to have_content("1. Mr Bean (you)\n2.\n3.\n4.\n5.")

    
    (number_of_players - 1).times { Player.create(game: game) }

    click_on 'Start the game already!'
    expect(page).to have_content("Cups:\nThe Accursèd Chalice\nMerlin’s Goblet\nThe Holy Grail")

    visit root_path
    fill_in 'game_slug', with: 'test'
    click_on 'Next'
    expect(page).to have_content('Player: Mr Bean') # Remembers the player
    expect(page).to have_content("Cups:\nThe Accursèd Chalice\nMerlin’s Goblet\nThe Holy Grail")
    expect(current_path).to match(/test/)
  end

  scenario 'game not found' do
    visit root_path
    fill_in 'game_slug', with: 'sausages'
    click_on 'Next'
    expect(page).to have_content('No game called sausages was found.')
  end

  context 'game is already full' do
    let(:game) { Game.create(slug: 'full', number_of_players: 3) }
    before { 3.times { Player.create(game: game) } }

    context 'when the player does NOT belong to the game' do
      scenario 'reject user' do
        visit game_path(slug: 'full')
        expect(page).to have_content('Sorry, the game ‘full’ is full.')
      end
    end

    context 'when the player DOES belong to the game' do
      before do
        visit root_path
        click_on 'Make new game'
        fill_in 'game_number_of_players', with: 5
        click_on 'Begin'
        fill_in 'player_name', with: 'Alice'
        click_on 'Create Player'
        game.players.last.delete
        Player.find_by(name: 'Alice').update!(game_id: game.id)
        game.players.reload
      end

      scenario 'allow user in' do
        visit game_path(slug: 'full')
        expect(page).to have_content("Cups:\nThe Accursèd Chalice\nMerlin’s Goblet\nThe Holy Grail")
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
