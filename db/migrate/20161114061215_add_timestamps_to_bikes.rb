class AddTimestampsToBikes < ActiveRecord::Migration[5.0]
  def change
    add_timestamps :bikes, null: true
  end
end
