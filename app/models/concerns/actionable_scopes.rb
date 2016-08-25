module ActionableScopes
  extend ActiveSupport::Concern

  included do

    scope :latest, -> { order(updated_at: :desc) }
    scope :by_distance, -> { order('distance') }

    scope :near, -> (longitude, latitude, max_distance = 1000) {
      where(%{
        ST_DWithin(
          ST_GeographyFromText(
            'SRID=4326;POINT(' || longitude || ' ' || latitude || ')'
          ),
          ST_GeographyFromText('SRID=4326;POINT(%f %f)'),
          %d
        )
      } % [longitude, latitude, max_distance])
    }

    scope :select_all_with_distance, -> (longitude, latitude) {
      if longitude.nil? || latitude.nil?
        select("*, 0 as distance")
      else
        select(%{*, 
          ST_Distance(
            ST_GeographyFromText(
              'SRID=4326;POINT(' || longitude || ' ' || latitude || ')'
            ),
            ST_GeographyFromText('SRID=4326;POINT(%f %f)')) as distance
        } % [longitude, latitude])
      end
    }

    scope :circle_for, -> (user) {
      where(user_id: user.friend_ids + [user.id])
    }
  end
end
