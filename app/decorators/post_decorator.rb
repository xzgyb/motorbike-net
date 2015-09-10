class PostDecorator < ApplicationDecorator
  delegate_all

  def replied_time
    "#{h.time_ago_in_words(object.updated_at)}前回复"
  end

  def user_name
    object.user.name
  end
end
