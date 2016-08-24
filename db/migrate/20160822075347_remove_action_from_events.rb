class RemoveActionFromEvents < ActiveRecord::Migration[5.0]
  def change
    remove_reference :events, :action
  end
end
