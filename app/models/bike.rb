class Bike < ApplicationRecord
  include GlobalID::Identification

  store_accessor :diag_info

  validates :module_id, presence:true, uniqueness: true

  belongs_to :user
  has_many :locations

  before_update do |bike|
    diag_info = bike.diag_info

    if diag_info && diag_info['notify'].present?
      bike.diag_info.delete('notify')
      BikeExceptionNotifyJob.perform_later(bike)
    end
  end
end
