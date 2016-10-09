class AddCommandsToBikes < ActiveRecord::Migration[5.0]
  def up
    add_column :bikes, :commands, :hstore, default: {}
    add_index :bikes, :commands, using: :gin
  end

  def down
    remove_column :bikes, :commands
    remove_index :bikes, :commands
  end
end
