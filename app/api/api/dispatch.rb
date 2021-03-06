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
        when ActiveRecord::RecordNotFound
          error!({result: 0, error: '数据不存在'}, 404)
        when ActiveRecord::RecordInvalid
          message = e.record.errors.full_messages.join(', ')
          error!({result: 0, error: message})
        when Grape::Exceptions::ValidationErrors
          error!({result: 0,
                  error: '参数不符合要求，请检查参数是否按照 API 要求传输',
                  validation_errors: e.errors}, 400)
        when Api::Errors::RespondErrors
          error!({result: 0, error: e.message})
        else
          Rails.logger.error "Api error: #{e}\n#{e.backtrace.join("\n")}"
          error!({result: 0, error: 'API 接口异常'})
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
      { result: 0, error: 'Page not found.' }
    end
  end
end
