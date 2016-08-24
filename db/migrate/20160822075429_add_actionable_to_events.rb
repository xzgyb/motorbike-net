class AddActionableToEvents < ActiveRecord::Migration[5.0]
  def change
    add_reference :events, :actionable, polymorphic: true, index: true 
  end
end
