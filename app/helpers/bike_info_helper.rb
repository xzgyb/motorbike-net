module BikeInfoHelper
  def bike_info_panel(caption, items)
    content_tag(:div, class: 'panel panel-info') do
      panel_header(caption) +
      panel_body(items)
    end
  end

  private

  def panel_header(caption)
    content_tag(:div, class: 'panel-heading') do
      content_tag(:h4, caption)
    end
  end

  def panel_body(items)
    content_tag(:div, class: 'panel-body') do
      items.inject('') { |result, item | result << panel_item(item) }.html_safe
    end
  end

  def panel_item(item)
    content_tag(:div, class: 'form-group') do
      content_tag(:label, item[0], class: 'col-sm-5') +
      content_tag(:p, item[1], class: 'col-sm-5')
    end
  end
end
