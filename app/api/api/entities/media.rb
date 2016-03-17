module Api::Entities
  class Media < Grape::Entity
    expose :_id, as: :id do |instance, options|
      instance._id.to_s
    end

    expose :type
    expose :url do |instance, options|
      env = options[:env]
      host_url = "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}"
      host_url + instance.media.url
    end

    root "medias", "media"
  end
end
