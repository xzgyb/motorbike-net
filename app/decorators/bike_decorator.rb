require 'china_unicom_iot_api'

class BikeDecorator < ApplicationDecorator 
  delegate :module_id, :iccid, :diag_info

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

  def remaining_data_usage
    return 0 if object.iccid.blank?

    api = ChinaUnicomIotApi.new(api_server:  ENV['CHINA_UNICOM_IOT_API_SERVER'],
                                user_name:   ENV['CHINA_UNICOM_IOT_USER_NAME'],
                                password:    ENV['CHINA_UNICOM_IOT_PASSWORD'],
                                license_key: ENV['CHINA_UNICOM_IOT_LICENSE_KEY'])

    api.get_remaining_data_usage(object.iccid)
  end
end
