class AddDistanceToActions < ActiveRecord::Migration[5.0]
  def change
    add_column :actions, :distance, :integer, default: 0
  end
end
