require 'rails_helper'

RSpec.feature 'Gameplay' do
  let(:word_api_slug) { 'test' }
  before { allow_any_instance_of(WordsApi).to receive(:get_word).and_return(word_api_slug) }

  # Remember that JS probably isn't running in the tests.

  context 'basic gameplay' do
    let(:game) { Game.find_by(slug: word_api_slug) }
    let(:number_of_players) { 3 }
    let(:number_of_evil_players_at_start) { 1 }

    scenario 'can create and view a game' do
      visit root_path
      click_on 'Make new game'
      fill_in 'game_number_of_players', with: number_of_players
      fill_in 'game_number_of_evil_players_at_start', with: number_of_evil_players_at_start
      click_on 'Create Game'
      fill_in 'player_name', with: 'Mr Bean'
      click_on 'Create Player'

      # Goes to lobby because not yet quorate
      expect(current_path).to match(/#{word_api_slug}/)
      expect(game.number_of_players).to eq number_of_players
      expect(page).to have_content('reload the page')
      visit game_path(slug: game.slug)
      expect(page).to have_content('Lobby')
      expect(page).not_to have_content('Start') # Because we are not quorate
      expect(page).to have_content("/games/#{word_api_slug}") # Displays the url to share
      expect(page).to have_content("1. Mr Bean (you)\n2.\n3.")

      (number_of_players - 1).times { Player.create(name: 'Slim Shady', game: game) }

      # Reload page to enable start button because test has no JS
      visit game_path(slug: game.slug)
      click_on 'Start (when all the players are here)'
      expect(page).to have_content("1\n2\n3")

      visit root_path
      fill_in 'game_slug', with: word_api_slug
      click_on 'Next'
      expect(page).to have_content('Mr Bean, you are') # Remembers the player
      expect(page).to have_content("1\n2\n3")

      # Players only see the names of cups they have quaffed.
      # Clicking a cup changes the player's allegiance.
      # This test is agnostic as to whether Mr Bean starts the game as evil or good.
      find('#merlins_goblet_anchor').click

      expect(page).to have_css('#merlins_goblet_quaffed_true')
      expect(page).to have_css('#accursed_chalice_quaffed_false')
      expect(page).to have_css('#holy_grail_quaffed_false')

      expect(find('#cupsSection')).to have_content('Goblet')
      expect(find('#cupsSection')).not_to have_content('Chalice')
      expect(find('#cupsSection')).not_to have_content('Grail')

      expect(page).to have_content('Mr Bean, you are Good')

      find('#accursed_chalice_anchor').click

      expect(page).to have_css('#merlins_goblet_quaffed_true')
      expect(page).to have_css('#accursed_chalice_quaffed_true')
      expect(page).to have_css('#holy_grail_quaffed_false')

      expect(find('#cupsSection')).to have_content('Goblet')
      expect(find('#cupsSection')).to have_content('Chalice')
      expect(find('#cupsSection')).not_to have_content('Grail')

      expect(page).to have_content('Mr Bean, you are Evil')
    end
  end

  scenario 'game not found' do
    visit root_path
    fill_in 'game_slug', with: 'sausages'
    click_on 'Next'
    expect(page).to have_content('No game called sausages was found.')
  end

  context 'when leaving a game' do
    let(:word_api_slug) { 'kurz' }
    let!(:game) { Game.create(slug: 'kurz', number_of_players: 3, number_of_evil_players_at_start: 1) }
    let!(:other_player_1) { Player.create(name: 'Gandalf', game: game) }
    let!(:other_player_2) { Player.create(name: 'Elrond', game: game) }

    before do
      visit game_path(slug: 'kurz')
      fill_in 'player_name', with: 'Mr Bean'
      click_on 'Create Player'
      click_on 'Start (when all the players are here)'
      other_player_1.destroy
      other_player_2.destroy
      click_on 'Leave Game'
    end

    scenario 'trashes the game' do
      visit game_path(slug: word_api_slug)
      expect(Game.find_by(slug: word_api_slug)).to be_trashed
      expect(page).to have_content('no longer exists.')
    end

    context 'when playing a new game' do
      let(:word_api_slug) { 'new_game' }

      scenario 'requires a player to be created because session was destroyed' do
        visit root_path
        click_on 'Make new game'
        fill_in 'game_number_of_players', with: 4
        fill_in 'game_number_of_evil_players_at_start', with: 1
        click_on 'Create Game'
        expect(page).to have_content('new player')
      end
    end
  end

  context 'when the game is already full' do
    let(:full_game) { Game.create(slug: 'full', number_of_players: 5) }
    before { 5.times { Player.create(name: 'Spartacus', game: full_game) } }

    context 'when the player does NOT belong to the game' do
      scenario 'reject user' do
        visit game_path(slug: 'full')
        expect(page).to have_content('Sorry, the game ‘full’ is full.')
      end
    end

    context 'when the player DOES belong to the game' do
      let(:slug) { 'game_with_room_for_10' }

      before do
        visit root_path
        click_on 'Make new game'
        fill_in 'game_number_of_players', with: 10
        fill_in 'game_number_of_evil_players_at_start', with: 1
        click_on 'Create Game'
        fill_in 'player_name', with: 'Alice'
        click_on 'Create Player'
        full_game.players.last.delete
        Player.find_by(name: 'Alice').update!(game: full_game)
        full_game.players.reload
      end

      scenario 'allow user in' do
        visit game_path(slug: 'full')
        expect(page).to have_content('Lobby')
      end
    end
  end
end
