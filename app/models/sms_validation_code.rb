require 'validation_code_generator'

class SmsValidationCode
  include Mongoid::Document
  include Mongoid::Timestamps

  include Expirable

  field :validation_code, type: String
  field :phone, type: String
  field :expires_in, type: Integer

  DEFAULT_EXPIRS_IN = 10 * 60  # Default expire time is 10 minutes.

  class << self
    # generate a sms validation code object, then save.
    def generate(phone)
      self.create(phone: phone) do |doc|
        doc.validation_code = ValidationCodeGenerator.gen_code
        doc.expires_in = DEFAULT_EXPIRS_IN
      end
    end

    # find SmsValidationCode object with phone and validation_code
    def find(phone, validation_code)
      where(phone: phone, validation_code: validation_code).first
    end
  end

end
