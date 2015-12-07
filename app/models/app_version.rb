class AppVersion
  include Mongoid::Document
  include Mongoid::Timestamps

  field :version, type: String
  field :changelog, type: String

  mount_uploader :app, AppUploader

  scope :ordered, -> { order_by(:created_at => :desc) }
  scope :newest, -> { ordered.limit(1) }
  scope :by_version, ->(version) { AppVersion.where(version: version) }

  validates :version, presence: true, uniqueness: true
  validates :app, presence: true

  class GreatestVersionValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      newest_app_version = AppVersion.newest.first
      if newest_app_version
        if Versionomy.parse(value) <
            Versionomy.parse(newest_app_version.version)
          record.errors.add attribute, :greatest_version
        end
      end
    end
  end

  validates :version, greatest_version: true
end