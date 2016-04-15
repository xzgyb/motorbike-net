module Api::Entities
  class Article < Grape::Entity
    format_with(:time) { |dt| dt.strftime("%Y-%m-%d %H:%M:%S") }

    expose :_id, as: :id do |instance, options|
      instance._id.to_s
    end
    expose :title
    expose :title_image_url do |instance, options|
      instance.title_image_url
    end

    expose :body, if: lambda { |_, options| options[:export_body] == true }

    with_options(format_with: :time) do
      expose :updated_at
    end

    root "articles", "article"
  end
end
