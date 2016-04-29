module GeoNearable
  extend ActiveSupport::Concern

  included do
    attr_accessor :distance
  end

  class_methods do
    
    def near(near, opts = {})
      opts = { page: 1, per_page: 10, max_distance: 6371 }.merge(opts)

      page, per_page, max_distance  = opts[:page], opts[:per_page], opts[:max_distance]

      pipeline = [
        { "$geoNear" => {
          "near" => near,
          "distanceField" => "distance",
          "distanceMultiplier" => 6371000,
          "maxDistance" => max_distance.fdiv(6371),
          "spherical" => true }
        }
      ]

      count = collection.aggregate(pipeline).count

      if page && per_page
        pipeline << { '$skip' => ((page.to_i - 1) * per_page) }
        pipeline << { '$limit' => per_page }
      end

      if opts[:match] 
        pipeline << { '$match' => opts[:match] }
      end

      if opts[:sort]
        pipeline << { '$sort' => opts[:sort] }
      end

      models = fetch_models(pipeline)

      models.instance_eval <<-EVAL
        def current_page
          #{page}
        end
        def total_pages
          #{count.modulo(per_page).zero? ? (count / per_page) : ((count / per_page) + 1)}
        end
        def total_count
          #{count}
        end
        def next_page
          #{page} == total_pages ? nil : #{page + 1} 
        end
        def prev_page
          #{page} == 1 ? nil : #{page - 1}
        end
        def limit_value
          #{per_page}
        end          
      EVAL

      models
    end

    private
      def fetch_models(pipeline)
        aggregate_results = collection.aggregate(pipeline)

        ids = aggregate_results.map { |e| e['_id'].to_s }
        models = self.find(ids)

        models.each do |model|
          select_result = aggregate_results.select do |p|
            p["_id"] == model.id 
          end
          model.distance = select_result.first['distance'] 
        end

        models.sort! { |a, b| a.distance <=> b.distance }
      end
  end
end
