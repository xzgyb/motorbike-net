# encoding: utf-8
require 'securerandom'

module Api::V1
  class Users < Grape::API
    SMS_CONTENTS = {
        1 => "【美行科技】验证码：%s，请在十分钟内填写，您正在注册美行账号。",
        2 => "【美行科技】验证码：%s，请在十分钟内填写，您正在登陆美行科技。",
        3 => "【美行科技】验证码：%s，请在十分钟内填写，您正在重置美行科技的账号密码。"
    }

    resource :users do

      desc 'get sms validation code'
      params do
        requires :phone, type: String, desc: 'phone number'
        optional :type, type: Integer, default: 1, values: 1..3,
                 desc: "get sms validation code type, 1: register, 2: login, 3: reset"
      end
      get :validation_code do
        phone, type = params[:phone], params[:type]

        validation_code_object = SmsValidationCode.generate(phone)
        sms_content = SMS_CONTENTS[type] % [validation_code_object.validation_code]

        ChinaSMS.use(:yunxin, username: 'mhkjcf', password: 'mhkjcf467')
        #result = ChinaSMS.to(phone, sms_content)
        result = {success: true, code: '1231232132'}

        if result[:success]
          respond_ok
        else
          Rails.logger.error "Send sms error: result code is #{result[:code]}"
          error!("获取短信校验码失败，错误代码=#{result[:code]}")
        end
      end

      desc 'register user with phone and validation code'
      params do
        requires :phone, type: String, desc: 'phone number'
        requires :validation_code, type: String, desc: 'validation code'
      end
      post :register do
        phone, validation_code = params[:phone], params[:validation_code]
        validation_code_object = SmsValidationCode.find(phone, validation_code)
        
        if validation_code_object.nil?
          error!("不存在此校验码，请重新获取！")
        end

        if validation_code_object.expired?
          validation_code_object.destroy
          error!("校验码已过期，请重新获取！")
        end

        user = User.where(phone: phone).first
        if user
          validation_code_object.destroy
          error!('该用户已存在，无法注册！')
        end

        user = User.new(phone: phone,
                        oauth_login_code: SecureRandom.hex(10))

        if not user.save(validate: false)
          error!('用户注册失败!')
        end

        validation_code_object.destroy
        respond_ok(oauth_login_code: user.oauth_login_code)
      end

      get :test do
        doorkeeper_authorize!
        {'phone': current_user.phone}
      end
    end
  end
end
