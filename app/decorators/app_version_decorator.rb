class AppVersionDecorator < ApplicationDecorator
  delegate_all

  def created_at
    object.created_at.to_formatted_s(:db)
  end

  def changelog
    object.changelog.truncate(80)
  end
end
