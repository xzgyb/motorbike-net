class AddPointIndexToActions < ActiveRecord::Migration[5.0]
  def up
    execute %{
      create index index_on_actions_location ON actions using gist(
        ST_GeographyFromText(
          'SRID=4326;POINT(' || actions.longitude || ' ' || actions.latitude || ')'
        )
      )
    }
  end

  def down
    execute %{drop index index_on_actions_location}
  end
end
