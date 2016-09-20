class CreateLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :likes do |t|
      t.references :living, foreign_key: true
      t.references :user, foreign_key: true
    end
  end
end
