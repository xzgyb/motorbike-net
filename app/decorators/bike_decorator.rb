class BikeDecorator < ApplicationDecorator 
  delegate :diag_info

  def name
    object.name.blank? ? I18n.t("none") : object.name
  end

  def location
    "#{object.longitude}, #{object.latitude}"  
  end

  def battery
    "#{(object.battery * 100).to_i}%"
  end

  def travel_mileage
    I18n.t("travel_mileage_format") % [object.travel_mileage]
  end
end
