module Api
  module Helpers
    include DoorkeeperTokenHelper

    PaginateRecord = Struct.new(:current_page, 
                                :next_page,
                                :prev_page,
                                :total_pages,
                                :total_count)

    def respond_ok(response = nil)
      present response if response
      present :result, 1
    end

    def respond_error!(message)
      raise Errors::RespondErrors, message
    end

    def api_request(resource)
      resource.api_request = true
      yield resource
    end

    def current_user
      @current_user ||= User.where(id: doorkeeper_token.resource_owner_id).first if doorkeeper_token
    end

    def paginate(resource)
      resource = resource.page(params[:page] || 1)
      if params[:per_page]
        resource = resource.per(params[:per_page])
      end

      resource
    end

    def paginate_record_for(resource)
      result = PaginateRecord.new
      result.members.each { |member| result[member] = resource.send(member) }
      result
    end

    def normalize_uploaded_file_attributes(attrs)
      if attrs.present?
        attrs.each do |attr|
          if attr[:file].present?
            attr[:file] = ActionDispatch::Http::UploadedFile.new(attr[:file])
          end
        end
      end
    end
  end
end
