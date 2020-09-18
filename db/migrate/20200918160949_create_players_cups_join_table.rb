class CreatePlayersCupsJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_join_table :players, :cups
  end
end
