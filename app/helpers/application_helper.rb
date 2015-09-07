module ApplicationHelper
  def current_user?(user)
    current_user.email == user.email
  end
end
