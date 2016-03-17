class ArticleDecorator < Draper::Decorator
  delegate_all

  def update_time
    object.updated_at.strftime("%Y-%m-%d %H:%M:%S")
  end
end
