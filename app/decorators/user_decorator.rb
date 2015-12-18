class UserDecorator < ApplicationDecorator 
  delegate_all
  decorates_association :bikes
end
