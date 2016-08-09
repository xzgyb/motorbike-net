class AddPlaceToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :place, :string
  end
end
