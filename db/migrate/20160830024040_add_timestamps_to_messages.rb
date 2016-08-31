class AddTimestampsToMessages < ActiveRecord::Migration[5.0]
  def change
    add_timestamps :messages
  end
end
