class AddActionTypeToActions < ActiveRecord::Migration[5.0]
  def change
    add_column :actions, :action_type, :integer, default: 0
  end
end
