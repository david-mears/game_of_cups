class AddLabelToCups < ActiveRecord::Migration[6.0]
  def change
    add_column :cups, :label, :string
  end
end
