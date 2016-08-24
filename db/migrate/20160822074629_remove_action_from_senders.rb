class RemoveActionFromSenders < ActiveRecord::Migration[5.0]
  def change
    remove_reference :senders, :action
  end
end
