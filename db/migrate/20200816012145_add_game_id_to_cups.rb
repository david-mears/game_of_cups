class AddGameIdToCups < ActiveRecord::Migration[6.0]
  def change
    add_reference :cups, :game, foreign_key: true
  end
end
