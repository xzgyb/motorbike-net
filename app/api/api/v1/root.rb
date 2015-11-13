module Api::V1
  class Root < Grape::API
    version 'v1'

    # Mount api
    mount Bikes
    mount Users
  end
end