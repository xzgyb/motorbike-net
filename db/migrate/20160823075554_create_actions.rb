class CreateActions < ActiveRecord::Migration[5.0]
  def up
    create_table :actions do |t|
      t.decimal  :longitude, precision: 9, scale: 6, default: 0
      t.decimal  :latitude,  precision: 9, scale: 6, default: 0
      t.timestamps
      t.references :actionable, polymorphic: true, index: true 
      t.belongs_to :user
    end

    create_point_index :actions
  end

  def down
    drop_table :actions
    drop_point_index :actions
  end

  private
    def create_point_index(table_name) 
      execute %{
        create index index_on_#{table_name}_location ON #{table_name} using gist(
          ST_GeographyFromText(
            'SRID=4326;POINT(' || #{table_name}.longitude || ' ' || #{table_name}.latitude || ')'
          )
        )
      }
    end

    def drop_point_index(table_name)
      execute %{drop index index_on_#{table_name}_location}
    end
end
