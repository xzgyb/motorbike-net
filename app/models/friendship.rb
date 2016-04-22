class Friendship 
  include Mongoid::Document

  field :requested_at, type: DateTime
  field :accepted_at, type: DateTime
  field :status, type: String
  field :friend_id, type: BSON::ObjectId

  STATUS_ALREADY_FRIENDS     = 1
  STATUS_ALREADY_REQUESTED   = 2
  STATUS_IS_YOU              = 3
  STATUS_FRIEND_IS_REQUIRED  = 4
  STATUS_FRIENDSHIP_ACCEPTED = 5
  STATUS_REQUESTED           = 6
  
  scope :pending,   -> { where(status: 'pending') }
  scope :accepted,  -> { where(status: 'accepted') }
  scope :requested, -> { where(status: 'requested') }
  
  # associations
  belongs_to :user
  
  # indexes
  index user_id: 1
  index friend_id: 1
  index status: 1

  def pending?
    status == 'pending'
  end
  
  def accepted?
    status == 'accepted'
  end
  
  def requested?
    status == 'requested'
  end

  def accept!
    update_attribute(:status, 'accepted')
  end
end
