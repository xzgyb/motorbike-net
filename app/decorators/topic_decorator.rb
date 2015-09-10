class TopicDecorator < ApplicationDecorator
  delegate_all

  def update_time
    object.updated_at.strftime("更新于 %Y-%m-%d %H:%M:%S")
  end

  def views_count
    "#{object.views_count}次阅读"
  end

  def published_time
    "#{object.user.name}于#{h.time_ago_in_words(object.created_at)}前发布" 
  end

  def last_replied_time
    last_post = Topic.last_post(object)
    if not last_post.nil?
      "最后由#{last_post.user.name}于#{h.time_ago_in_words(last_post.updated_at)}前回复" 
    else
      ""
    end 
  end

  def total_replies_count
    "共#{object.posts.count}个回复"
  end

  def user_name
    object.user.name
  end
end
