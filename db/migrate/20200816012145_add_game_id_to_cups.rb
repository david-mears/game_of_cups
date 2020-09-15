class AddGameIdToCups < ActiveRecord::Migration[6.0]
  def change
    add_column :cups, :game_id, :uuid
  end
end
