require 'validation_code_generator'

class SmsValidationCode < ApplicationRecord 
  self.inheritance_column = :_type 

  include Expirable

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
