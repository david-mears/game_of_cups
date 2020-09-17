class ChangePlayersDefaultAllegiance < ActiveRecord::Migration[6.0]
  def change
    # Set default allegiance to good
    change_column :players, :allegiance, :integer, default: 1
  end
end
