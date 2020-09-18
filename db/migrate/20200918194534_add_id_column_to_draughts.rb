class AddIdColumnToDraughts < ActiveRecord::Migration[6.0]
  def change
    add_column :draughts, :id, :primary_key
  end
end
