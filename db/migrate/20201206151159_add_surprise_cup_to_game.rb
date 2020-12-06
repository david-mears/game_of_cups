class AddSurpriseCupToGame < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :surprise_cup, :boolean, default: false
  end
end
