class AddTakeAlongSomethingToReceiversAndSenders < ActiveRecord::Migration[5.0]
  def change
    add_reference :receivers, :take_along_something
    add_reference :senders, :take_along_something
  end
end
