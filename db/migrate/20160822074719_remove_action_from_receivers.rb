class RemoveActionFromReceivers < ActiveRecord::Migration[5.0]
  def change
    remove_reference :receivers, :action
  end
end
