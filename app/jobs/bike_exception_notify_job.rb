require 'sms_sender'

class BikeExceptionNotifyJob < ActiveJob::Base
  queue_as :default

  SMS_NOTIFY_CONTENT = <<-CONTENT
【美行科技】验证码：您的爱车%s发生异常状况，如下:
%s
  CONTENT

  def perform(bike)
#    send_sms(bike)
    broadcast_bike_exception(bike)
  end

  private
    def send_sms(bike)
      content = SMS_NOTIFY_CONTENT % [bike.name, 
                                      bike.diag_info.keys.join(", ")]
      phone   = bike.user.phone

      SMSSender.send(phone, content)
    end

    def broadcast_bike_exception(bike)
      data = { name: bike.name,
               status: -1,
               diag_info: bike.diag_info }

      ActionCable.server.broadcast("bike:#{bike.user.id}",
                                   bike: data)
    end
end
