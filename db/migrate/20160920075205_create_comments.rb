class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.references :living, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :reply_to_user_id, default: nil
      t.text :content, default: ''
    end
  end
end
