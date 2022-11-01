class Connections::Connection
  class ConnectionNotfound < StandardError; end

  def self.for_connection(connection)
    connection_map = {
      Connections::Canvas::IDENTIFIER => Connections::Canvas
    }

    klass = connection_map[connection.identifier]

    raise(ConnectionNotfound, "No connection found for #{connection.identifier}") if klass.blank?

    klass.new(connection)
  end

  def initialize(connection)
    @connection = connection
  end

  def authorization_url(strategy: Strategies::Strategy::TYPES.authorization_code)
    Strategies::Strategy.for(strategy).authorization_endpoint(@connection, parameters: authorization_parameters)
  end

  def cookie_name
    "#{@connection.identifier}_authz_state"
  end

  def cookie_value
    Digest::SHA256.hexdigest state
  end

  def access_token
  end

  def user
  end

  protected

  def state
    @state ||= Security::State.for_connection(@connection)
  end

  def redirect_uri
    Rails.application.routes.url_helpers.connections_callback_url(
      host: @connection.tenant.regional_tenant.tenant_hosts.first.host
    )
  end

  def authorization_parameters
    { state:, redirect_uri: }
  end

  def client_id
  end

  def client_secret
  end
end
