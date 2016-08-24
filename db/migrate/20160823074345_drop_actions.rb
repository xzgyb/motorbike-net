class DropActions < ActiveRecord::Migration[5.0]
  def up
    drop_table :actions
  end

  def down
    create_table :actions do |t|
      t.integer  :category,  default: 0
      t.string   :title
      t.string   :place
      t.datetime :start_at
      t.datetime :end_at
      t.text     :content,   default:   ""
      t.decimal  :price,     precision: 10, scale: 2, default: 0
      t.decimal  :longitude, precision: 9, scale: 6, default: 0
      t.decimal  :latitude,  precision: 9, scale: 6, default: 0
      t.integer  :distance, default: 0
      t.timestamps
      t.belongs_to :user
    end
  end
end
