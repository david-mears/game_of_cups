class AddNumberOfEvilPlayersToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :number_of_evil_players_at_start, :integer
  end
end
