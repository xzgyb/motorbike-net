class ChinaUnicomIotApi
  def initialize(api_server:, user_name:, password:, license_key:)
    @api_server, @user_name, @password, @license_key = 
      api_server, user_name, password, license_key
  end

  def get_remaining_data_usage(iccid)
    wsdl_url = "https://#{@api_server}/ws/schema/Terminal.wsdl"
    client   = Savon.client(wsdl: wsdl_url,
                            wsse_auth: [@user_name, @password], log:false)

    response = client.call(:get_terminal_details,
                           message: {
                              :messageId => '', 
                              :version => '',
                              :licenseKey => @license_key,
                              :iccids => {:iccid => iccid}})

    body = response.body[:get_terminal_details_response]

    month_to_date_data_usage = 
      body[:terminals][:terminal][:month_to_date_data_usage].to_f

    "%.2f" % [50 - month_to_date_data_usage]
  end
end
