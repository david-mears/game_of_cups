class ChangeCupsGameReferenceToForeignKey < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :cups, :games
  end
end
