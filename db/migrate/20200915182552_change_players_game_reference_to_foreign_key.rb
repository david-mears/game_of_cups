class ChangePlayersGameReferenceToForeignKey < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :players, :games
  end
end
