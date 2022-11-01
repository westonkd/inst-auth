class Connections::Connection
  def initialize(connection)
    @connection = connection
  end

  def authorization_url(strategy: Strategies::Strategy::TYPES.authorization_code)
    Strategies::Strategy.for(strategy).authorization_endpoint(@connection, parameters: authorization_parameters)
  end

  def state_cookie_value
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

  def authorization_parameters
    { state:, redirect_uri: "https://asdfasdfa.asdfasdf.asdfasdf/redirect/#{@connection.identifier}" }
  end

  def client_id
  end

  def client_secret
  end
end
