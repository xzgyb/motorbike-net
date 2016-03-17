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

  def nav_user_items(user_name)
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
        content_tag(:li) { link_to('车辆信息', user_bikes_path(current_user)) } + 
        content_tag(:li) { link_to('媒体文件', medias_path) }
      end

      caption_tag + items_tag
    end
  end

  def nav_manage_items
    content_tag(:li, class: "dropdown") do
      caption_tag = link_to('#', id: 'manage-drop',
                            'class' => 'dropdown-toggle roll',
                            'aria-expanded' => 'false',
                            'aria-haspopup' => 'true',
                            'role' => 'button',
                            'data-toggle' => 'dropdown') do
        content_tag(:span, 'data-title' => '后台管理') { '后台管理' }
      end

      items_tag = content_tag(:ul, 'class' => 'dropdown-menu',
                              'aria-labelledby' => 'manage-drop') do
        content_tag(:li) { link_to('用户管理', users_path) } +
        content_tag(:li) { link_to('车辆管理', bikes_path) } +
        content_tag(:li) { link_to('App版本管理', app_versions_path) } +
        content_tag(:li) { link_to('时尚资讯管理', articles_path) }
      end

      caption_tag + items_tag
    end
  end

  def article_controller?
    controller_name == 'articles'
  end
end
