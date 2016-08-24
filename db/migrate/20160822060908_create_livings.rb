class CreateLivings < ActiveRecord::Migration[5.0]
  def change
    create_table :livings do |t|
      t.string :title
      t.string :place
      t.text :content, default: ""
      t.decimal  :longitude, precision: 9, scale: 6, default: 0
      t.decimal  :latitude,  precision: 9, scale: 6, default: 0
      t.integer :distance, default: 0
      t.belongs_to :user
      t.timestamps
    end
  end
end
