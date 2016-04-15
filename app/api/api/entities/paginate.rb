module Api::Entities
  class Paginate < Grape::Entity
    expose :current_page, :next_page, :prev_page, :total_pages, :total_count
    root "", "paginate_meta"
  end
end
