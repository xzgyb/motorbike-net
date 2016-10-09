module Api::Entities
  class Bike < Grape::Entity
    expose :id,
           :name,
           :module_id,
           :longitude,
           :latitude,
           :battery,
           :travel_mileage,
           :diag_info,
           :commands

    root "bikes", "bike"
  end
end
