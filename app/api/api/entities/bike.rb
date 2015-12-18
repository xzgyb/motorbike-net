module Api::Entities
  class Bike < Grape::Entity
    expose :_id, as: :id do |instance, options|
      instance._id.to_s
    end

    expose :name
    expose :module_id
    expose :longitude
    expose :latitude
    expose :battery
    expose :travel_mileage
    expose :diag_info

    root "bikes", "bike"
  end
end