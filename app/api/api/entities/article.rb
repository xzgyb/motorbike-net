module Api::Entities
  class Article < Grape::Entity
    format_with(:time) { |dt| dt.strftime("%Y-%m-%d %H:%M:%S") }

    expose :id, :title, :title_image_url
    expose :body, if: lambda { |_, options| options[:export_body] == true }

    with_options(format_with: :time) do
      expose :updated_at
    end

    root "articles", "article"
  end
end
