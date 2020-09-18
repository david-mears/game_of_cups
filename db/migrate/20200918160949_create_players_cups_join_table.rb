class CreatePlayersCupsJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_join_table :players, :cups, foreign_key: true
  end
end
