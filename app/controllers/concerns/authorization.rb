module Authorization
  extend ActiveSupport::Concern

  class AuthorizationError < StandardError; end

  def validate_redirect_uris
    return if application.redirect_uris.include? params[:redirect_uri]

    raise AuthorizationError, "Invalid redirect URI: #{params[:redirect_uri]}"
  end

  def validate_response_type
    return if application.supports_response_type? params[:response_type]

    raise AuthorizationError, "Invalid response type for #{application.application_type}: #{params[:response_type]}"
  end

  def validate_scope
    # TODO
  end

  def application
    @application ||= begin
      Application.find_by(client_id: params[:client_id]) || (
        raise AuthorizationError, "Unknown client_id: #{params[:client_id]}"
      )
    end
  end
end
