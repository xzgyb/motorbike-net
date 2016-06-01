module Api::Entities
  class Media < Grape::Entity
    expose :id, :type

    expose :url do |instance, options|
      env = options[:env]
      host_url = "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}"
      host_url + instance.media.url
    end

    root "medias", "media"
  end
end
