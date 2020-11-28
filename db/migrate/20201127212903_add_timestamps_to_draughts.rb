class AddTimestampsToDraughts < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :draughts, default: Time.new(2020, 11, 27)
    change_column_default :draughts, :created_at, from: Time.new(2020, 11, 27), to: nil
    change_column_default :draughts, :updated_at, from: Time.new(2020, 11, 27), to: nil
  end
end
