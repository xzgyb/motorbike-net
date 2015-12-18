module RegistrationsHelper
  def edit_registrations_error_messages!
    return '' if resource.errors.empty?

    # Delete bikes error, and get it's detail error messages by
    # calling bikes_errors_messages_tag.
    resource.errors.delete(:bikes) if resource.errors.include?(:bikes)

    messages = messages_tag_for_errors(resource.errors)
    bikes_messages = bikes_errors_messages_tag(resource)

    messages += bikes_messages unless bikes_messages.blank?

    sentence = I18n.t('errors.messages.not_saved',
                      count: resource.errors.count,
                      resource: resource.class.model_name.human.downcase)

    html = <<-HTML
    <div class="alert alert-danger alert-block">
      <button type="button" class="close" data-dismiss="alert">⨉</button>
      <h5>#{sentence}</h4>
      #{messages}
    </div>
    HTML

    html.html_safe
  end

  private
    def messages_tag_for_errors(errors)
      errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    end

    def bikes_errors_messages_tag(user)
      (user.bikes || []).inject("") do |messages, bike|
        if bike.errors.empty?
          messages
        else
          messages << messages_tag_for_errors(bike.errors)
        end
      end
    end
end