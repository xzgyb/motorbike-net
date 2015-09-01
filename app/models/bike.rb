class Bike
  include Mongoid::Document
  embedded_in :user

  field :name, type: String, default: ''
  field :longitude, type: Float, default: 0
  field :latitude, type: Float, default: 0
  field :battery, type: Float, default: 0
  field :travel_mileage, type: Float, default: 0

  def name
    self[:name].empty? ? I18n.t("none") : self[:name]
  end

  def location
    "#{self.longitude}, #{self.latitude}"  
  end

  def battery
    "#{(self[:battery] * 100).to_i}%"
  end

  def travel_mileage
    I18n.t("travel_mileage_format") % [self[:travel_mileage]]
  end
end
