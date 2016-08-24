class CreateOrderTakes < ActiveRecord::Migration[5.0]
  def change
    create_table :order_takes do |t|
      t.references :take_along_something, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
