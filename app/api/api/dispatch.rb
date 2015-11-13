require 'doorkeeper/grape/helpers'

module Api
  class Dispatch < Grape::API
    prefix :api
    format :json
    content_type :json, 'application/json;charset=utf-8'
    default_error_formatter :json

    # Handle errors.
    rescue_from :all do |e|
      case e
        when Mongoid::Errors::DocumentNotFound
          rack_response({status: 'error', error: '数据不存在'}.to_json, 404)
        when Grape::Exceptions::ValidationErrors
          rack_response({status: 'error',
                         error: '参数不符合要求，请检查参数是否按照 API 要求传输',
                         validation_errors: e.errors}.to_json, 400)
        else
          Rails.logger.error "Api error: #{e}\n#{e.backtrace.join("\n")}"
          rack_response({status: 'error', error: 'API 接口异常'}.to_json, 500)
      end
    end

    # Include helper functions.
    helpers Doorkeeper::Grape::Helpers
    helpers Api::Helpers

    # Mount resource api of api version 1.
    mount V1::Root

    # Route unknown paths.
    route :any, '*path' do
      status 404
      { status: 'error', error: 'Page not found.' }
    end
  end
end