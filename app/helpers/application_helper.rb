module ApplicationHelper
  def current_user?(user)
    return false if user.nil?
    return false if current_user.nil?
    current_user.email == user.email
  end
end
