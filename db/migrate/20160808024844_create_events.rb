class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :title
      t.text :content, default: ""
      t.datetime :start_at
      t.datetime :end_at
      t.decimal  :longitude, precision: 9, scale: 6, default: 0
      t.decimal  :latitude,  precision: 9, scale: 6, default: 0
      t.integer  :distance, default: 0
      t.integer :event_type, default: 0
      t.belongs_to :user
      t.integer :action_id
      t.string :image_path
      t.timestamps
    end
  end
end
