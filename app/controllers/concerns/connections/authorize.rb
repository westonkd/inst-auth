module Connections::Authorize
  extend ActiveSupport::Concern

  def set_state_cookie
    cookies[connection.cookie_name] = {
      value: connection.cookie_value(client_params),
      expires: Security::State::COOKIE_TTL_MINUTES.minute.from_now,
      # importantly, set the domain of the cookie to be readable by the
      # regional tenant. This is the tenant that handles the redirect
      domain: connection_model.tenant.regional_tenant.tenant_hosts.first.host
    }
  end

  def connection_model
    # TODO: Renoamve Connections::Connection to something else :facepalm:
    @connection_model = ::Connection.find_by!(identifier: params[:identifier])
  end

  def connection
    @connection ||= Connections::Connection.for_connection(connection_model)
  end

  def client_params
    # TODO: Ya, storing these from the get-go in cache would be nicer
    {
      client_state: params[:client_state],
      client_id: params[:client_id],
      client_redirecet_uri: params[:client_redirect_uri],
      client_response_type: params[:client_response_type]
    }
  end
end
