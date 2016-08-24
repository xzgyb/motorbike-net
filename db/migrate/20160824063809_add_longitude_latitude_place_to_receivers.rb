class AddLongitudeLatitudePlaceToReceivers < ActiveRecord::Migration[5.0]
  def change
    add_column :receivers, :longitude, :decimal, precision: 9, scale: 6, default: 0
    add_column :receivers, :latitude,  :decimal, precision: 9, scale: 6, default: 0
    add_column :receivers, :place, :string, default: ''
  end
end
