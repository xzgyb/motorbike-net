require 'validation_code_generator'

class SmsValidationCode
  include Mongoid::Document
  include Mongoid::Timestamps

  include Expirable

  field :validation_code, type: String
  field :phone, type: String
  field :expires_in, type: Integer
  field :type, type: Integer

  DEFAULT_EXPIRES_IN = 24 * 60 * 60  # Default expire time is 10 minutes.

  # Sms validation code type
  REGISTER_USER = 1
  LOGIN_USER    = 2
  RESET_PASSWORD = 3

  class << self
    # generate a sms validation code object, then save.
    def generate(phone, type)
      self.create(phone: phone) do |record|
        record.validation_code = ValidationCodeGenerator.gen_code
        record.expires_in = DEFAULT_EXPIRES_IN
        record.type = type
      end
    end

    # find SmsValidationCode object with phone and validation_code
    def find(phone, validation_code)
      where(phone: phone, validation_code: validation_code).first
    end
  end

end
