class Sender
  include Mongoid::Document

  field :name, type: String, default: ""
  field :phone, type: String, default: ""
  field :address, type: String, default: ""

  belongs_to :action
end
