class AppVersion < ApplicationRecord
  mount_uploader :app, AppUploader

  scope :ordered, -> { order(created_at: :desc) }
  scope :named, ->(name) { where("name ~* :name", name: name) }
  scope :versioned, ->(version) { where(version: version) }

  scope :newest, ->(name) {  named(name).ordered.limit(1) }
  scope :by_name_version, ->(name, version) { named(name).versioned(version) }

  validates :version, presence: true
  validates :app, presence: true

  class GreatestVersionValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      newest_app_version = AppVersion.newest(record.name).first
      if newest_app_version
        if Versionomy.parse(value) <=
            Versionomy.parse(newest_app_version.version)
          record.errors.add attribute, :greatest_version
        end
      end
    end
  end

  validates :version, greatest_version: true

  before_validation do |app_version|
    app_version.name = File.basename(app_version.app_url, '.*')
  end
end
