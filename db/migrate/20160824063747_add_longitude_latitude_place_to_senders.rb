class AddLongitudeLatitudePlaceToSenders < ActiveRecord::Migration[5.0]
  def change
    add_column :senders, :longitude, :decimal, precision: 9, scale: 6, default: 0
    add_column :senders, :latitude,  :decimal, precision: 9, scale: 6, default: 0
    add_column :senders, :place, :string, default: ''
  end
end
