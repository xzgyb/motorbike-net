class AddTitleAndLevelToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :title, :string
    add_column :users, :level, :string
  end
end
