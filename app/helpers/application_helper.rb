module ApplicationHelper

  def nav_item(caption, link_path, options = {})
    options.merge!(class: 'roll')

    content_tag(:li) do
      link_to(link_path, options) do
        content_tag(:span, caption, "data-title": caption)
      end
    end
  end

end
