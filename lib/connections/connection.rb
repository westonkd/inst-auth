class Connections::Connection
  class ConnectionNotfound < StandardError; end

  class << self
    def for_connection(connection)
      # TODO: This mapping should not live in code
      connection_map = {
        Connections::Canvas::IDENTIFIER => Connections::Canvas,
        'google' => Connections::OpenIdConnect
      }

      klass = connection_map[connection.identifier]

      raise(ConnectionNotfound, "No connection found for #{connection.identifier}") if klass.blank?

      klass.new(connection)
    end

    def cookie_value(state)
      Digest::SHA256.hexdigest state
    end

    def cookie_name(connection)
      "#{connection.identifier}_authz_state"
    end
  end

  def initialize(connection)
    @connection = connection
  end

  def authorization_url(response_type: ResponseTypes::ResponseType::TYPES.authorization_code, client_params: {})
    ResponseTypes::ResponseType
      .for(response_type)
      .authorization_endpoint(
        @connection, parameters: authorization_parameters(client_params)
      )
  end

  def token(code, response_type: ResponseTypes::ResponseType::TYPES.authorization_code)
    ResponseTypes::ResponseType.for(response_type).access_token(
      @connection,
      code,
      redirect_uri
    )
  end

  def cookie_name
    self.class.cookie_name(@connection)
  end

  def cookie_value(client_params = {})
    self.class.cookie_value state(client_params)
  end

  def user_from(token)
  end

  protected

  def state(client_params)
    Security::State.for_connection(@connection, client_params)
  end

  def redirect_uri
    Rails.application.routes.url_helpers.connections_callback_url(
      host: @connection.callback_host || @connection.tenant.regional_tenant.tenant_hosts.first.host
    )
  end

  def scope
    @connection.scopes_supported.join(" ")
  end

  def authorization_parameters(client_params)
    {
      state: state(client_params),
      redirect_uri:,
      scope:
    }
  end

  def client_id
    @connection.client_id
  end

  def client_secret
    @conection.client_secret
  end
end
