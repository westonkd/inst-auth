module Strategies
  class AuthorizationCode
    class << self
      def authorization_endpoint(connection, parameters: {})
        Strategy.client_for_connection(connection).auth_code.authorize_url(parameters)
      end
    end
  end
end
