module ApplicationHelper

  def nav_item(caption, link_path, options = {})
    options.merge!(class: 'roll')

    content_tag(:li) do
      link_to(link_path, options) do
        content_tag(:span, caption, "data-title": caption)
      end
    end
  end

  def current_user_title
    current_user.name.blank? ? current_user.phone : current_user.name
  end

  def nav_user_item(user_name)
    content_tag(:li, class: "dropdown") do
      caption_tag = link_to('#', id: 'user-drop', 
              'class' => 'dropdown-toggle roll',
              'aria-expanded' => 'false',
              'aria-haspopup' => 'true',
              'role' => 'button',
              'data-toggle' => 'dropdown') do
        content_tag(:span, 'data-title' => user_name) { user_name }
      end

      items_tag = content_tag(:ul, 'class' => 'dropdown-menu',
                                   'aria-labelledby' => 'user-drop') do
        content_tag(:li) { link_to('用户信息', edit_user_registration_path) } +
        tag(:li, class: 'divider', role: 'separator') +
        content_tag(:li) { link_to('车辆信息', bike_info_path(current_user)) }
      end

      caption_tag + items_tag
    end
  end
end
