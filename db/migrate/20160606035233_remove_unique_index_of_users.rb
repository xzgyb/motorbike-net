class RemoveUniqueIndexOfUsers < ActiveRecord::Migration[5.0]
  def change
    remove_index :users, column: :email, unique: true, using: :btree
    remove_index :users, column: :name, unique: true, using: :btree

    add_index :users, :email, using: :btree
    add_index :users, :name, using: :btree
  end
end
