class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.references :user
      t.references :message_object, polymorphic: true
      t.boolean :is_read, default: false
    end
  end
end
