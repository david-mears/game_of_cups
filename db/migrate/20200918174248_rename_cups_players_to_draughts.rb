class RenameCupsPlayersToDraughts < ActiveRecord::Migration[6.0]
  def change
    rename_table :cups_players, :draughts
  end
end
