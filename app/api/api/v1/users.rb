# encoding: utf-8
require 'sms_sender'

module Api::V1
  class Users < Grape::API
    SMS_CONTENTS = {
        1 => "【美行科技】验证码：%s，请在十分钟内填写，您正在注册美行账号。",
        2 => "【美行科技】验证码：%s，请在十分钟内填写，您正在登陆美行科技。",
        3 => "【美行科技】验证码：%s，请在十分钟内填写，您正在重置美行科技的账号密码。"
    }

    resource :users do
      helpers do
        def user_params
          ActionController::Parameters.new(params).permit(
              :name, :password, :password_confirmation, :avatar)
        end

        def check_sms_validation_code!(type)
          phone, validation_code = params[:phone], params[:validation_code]
          validation_code_object = SmsValidationCode.find(phone, validation_code)

          if validation_code_object.nil?
            respond_error!("不存在此校验码，请重新获取！")
          end

          if validation_code_object.type != type
            respond_error!("校验码类型不匹配！")
          end

          if validation_code_object.expired?
            respond_error!("校验码已过期，请重新获取！")
          end
        end

        def user_with_phone!(phone)
          user = User.where(phone: phone).first
          respond_error!('该用户不存在，请注册！') unless user

          user
        end
      end

      desc 'Get sms validation code'
      params do
        requires :phone, type: String, desc: 'phone number'
        optional :type, type: Integer, default: 1, values: 1..3,
                 desc: "get sms validation code type, 1: register, 2: login, 3: reset"
      end
      get :validation_code do
        phone, type = params[:phone], params[:type]

        validation_code_object = SmsValidationCode.generate(phone, type)
        sms_content = SMS_CONTENTS[type] % [validation_code_object.validation_code]

        result = ::SMSSender.send(phone, sms_content)

        if result[:success]
          respond_ok
        else
          Rails.logger.error "Send sms error: result code is #{result[:code]}"
          respond_error!("获取短信校验码失败，错误代码=#{result[:code]}")
        end
      end

      desc 'Register user with phone and validation code'
      params do
        requires :phone, type: String, desc: 'phone number'
        requires :validation_code, type: String, desc: 'validation code'
      end
      post :register do
        check_sms_validation_code!(SmsValidationCode::REGISTER_USER)

        phone = params[:phone]
        user = User.where(phone: phone).first

        respond_error!('该用户已存在，无法注册！') if user

        user = User.new(phone: phone)

        respond_error!('用户注册失败!') unless user.save(validate: false)

        respond_ok(oauth_login_code: user.oauth_login_code)
      end

      desc 'Login user with phone and validation code'
      params do
        requires :phone, type: String, desc: 'phone number'
        requires :validation_code, type: String, desc: 'validation code'
      end
      post :login do
        check_sms_validation_code!(SmsValidationCode::LOGIN_USER)
        user = user_with_phone!(params[:phone])
        respond_ok(oauth_login_code: user.oauth_login_code)
      end

      desc 'Reset user password'
      params do
        requires :phone, type: String, desc: 'phone number'
        requires :validation_code, type: String, desc: 'validation code'
        requires :password, type: String, desc: 'user password'
        requires :password_confirmation, type: String, desc: 'user password confirmation'
      end
      put :reset do
        check_sms_validation_code!(SmsValidationCode::RESET_PASSWORD)
        user = user_with_phone!(params[:phone])

        api_request(user) do |user|
          user.password = params[:password]
          user.password_confirmation = params[:password_confirmation]

          user.save!
          respond_ok
        end
      end

      desc 'Update user info'
      params do
        optional :name, type: String, desc: 'user name'
        optional :password, type: String, desc: 'user password'
        optional :password_confirmation, type: String, desc: 'user password confirmation'
        optional :avatar, type: File
      end
      put :update do
        doorkeeper_authorize!

        if params[:avatar].present?
          params[:avatar] = ActionDispatch::Http::UploadedFile.new(params[:avatar])
        end

        api_request(current_user) do |user|
          user.update!(user_params)
          respond_ok
        end
      end

      # Get validation code api temporary.
      get "get_validation_code/:phone" do
        validation_code_object = SmsValidationCode.where(phone: params[:phone])
                                                  .order(created_at: :desc)
                                                  .first
        if validation_code_object.nil?
          respond_error!("validation code not found")
        else
          validation_code_object.validation_code
        end
      end

      # query users
      get "query(/:user_name_or_phone_or_email)" do
        doorkeeper_authorize!
        if params[:user_name_or_phone_or_email].blank?
          users = User.all.name_ordered
        else
          users = User.where('name ~* :name or phone ~* :phone or email ~* :email', 
                             name: "^#{params[:user_name_or_phone_or_email]}",
                             phone: "^#{params[:user_name_or_phone_or_email]}",
                             email: "^#{params[:user_name_or_phone_or_email]}").name_ordered
        end

        users = paginate(users)

        present users, with: Api::Entities::User
        present paginate_record_for(users), with: Api::Entities::Paginate

        respond_ok
      end

      # get current user info
      get :info do
        doorkeeper_authorize!
        present current_user, with: Api::Entities::User
        respond_ok
      end 

      # get user info
      get ":id" do
        doorkeeper_authorize!
        user = User.find(params[:id])
        present user, with: Api::Entities::User
        respond_ok
      end

      get :test do
        doorkeeper_authorize!
        {'phone': current_user.phone}
      end
    end

  end
end
