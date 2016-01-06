module Api::Entities
  class Media < Grape::Entity
    expose :_id, as: :id do |instance, options|
      instance._id.to_s
    end

    expose :type
    expose :url do |instance, options|
      env = options[:env]
      "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{instance.media.url}"
    end

    root "medias", "media"
  end
end
