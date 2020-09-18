class ChangeGameSlugToBeUnique < ActiveRecord::Migration[6.0]
  def change
    change_column :games, :slug, :string, unique: true
  end
end
