class CreateParticipations < ActiveRecord::Migration[5.0]
  def change
    create_table :participations do |t|
      t.references :activity, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
