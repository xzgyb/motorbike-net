module BikeInfoHelper
  def bike_info_panel(caption, items, updated_at = nil)
    content_tag(:div, class: 'panel panel-info') do
      panel_header(caption) +
      panel_body(items, updated_at)
    end
  end

  private

  def panel_header(caption)
    content_tag(:div, class: 'panel-heading') do
      content_tag(:h4, caption)
    end
  end

  def panel_body(items, updated_at = nil)
    content_tag(:div, class: 'panel-body') do
      items_list = items.inject('') { |result, item | result << panel_item(item) }

      if items.present? and updated_at
        items_list << panel_item(['更新时间', 
                                  updated_at.strftime('%Y-%m-%d %H:%M:%S')])
      end
      
      items_list.html_safe
    end
  end

  def panel_item(item)
    content_tag(:div, class: 'form-group') do
      content_tag(:label, item[0], class: 'col-sm-5') +
      content_tag(:p, item[1], class: 'col-sm-6')
    end
  end
end
