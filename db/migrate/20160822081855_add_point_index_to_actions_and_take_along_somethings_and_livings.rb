class AddPointIndexToActionsAndTakeAlongSomethingsAndLivings < ActiveRecord::Migration[5.0]

  def up
    create_point_index('activities')
    create_point_index('take_along_somethings')
    create_point_index('livings')
  end

  def down
    drop_point_index('activities')
    drop_point_index('take_along_somethings')
    drop_point_index('livings')
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
