class AddGameIdToPlayers < ActiveRecord::Migration[6.0]
  def change
    add_reference :players, :game, foreign_key: true
  end
end
