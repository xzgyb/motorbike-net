class RemoveImagePathFromEvents < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :image_path, :string
  end
end
