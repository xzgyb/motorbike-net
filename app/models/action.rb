class Action < ApplicationRecord
  include ActionableScopes

  belongs_to :user
  belongs_to :actionable, polymorphic: true

  enum action_type: { sponsor: 1, participant: 2 }
   
  def self.type_code(actionable_object)
    case actionable_object 
    when Activity then 0
    when Living then 1
    when TakeAlongSomething then 2
    end
  end
end
