class ChangeGameStatusColumnType < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE game_statuses AS ENUM ('draft', 'started', 'finished', 'trashed');
      ALTER TABLE games ALTER COLUMN status TYPE game_statuses USING status::game_statuses;
    SQL
  end

  def down
    execute <<-SQL
      DROP TYPE game_statuses;
    SQL
    change_column :games, :status, :string
  end
end
