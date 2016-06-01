class Bike < ApplicationRecord
  store_accessor :diag_info

  validates :module_id, presence:true, uniqueness: true

  belongs_to :user
  has_many :locations
end
