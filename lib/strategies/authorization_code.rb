module Strategies
  class AuthorizationCode
    class << self
      def authorization_endpoint(connection, parameters: {})
        Strategy.client_for_connection(connection).auth_code.authorize_url(parameters)
      end

      def access_token(connection, code, redirect_uri)
        Strategy
          .client_for_connection(connection)
          .auth_code
          .get_token(
            code,
            redirect_uri:
          ).token
      end
    end
  end
end
