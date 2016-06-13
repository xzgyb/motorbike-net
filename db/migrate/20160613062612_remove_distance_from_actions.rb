class RemoveDistanceFromActions < ActiveRecord::Migration[5.0]
  def change
    remove_column :actions, :distance, :integer
  end
end
