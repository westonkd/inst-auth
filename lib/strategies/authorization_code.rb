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

      def redirect_uri(user, state, redirect_uri, client_id)
        url = URI.parse(redirect_uri)

        query = url.query ? CGI.parse(url.query) : {}
        query.merge!(code: auth_code_for(user, client_id), state:)
        url.query = query.to_param

        url.to_s
      end

      private

      # TODO: Having the authz code be an JWT may result
      # in issues with URLs that are too long. This is especially
      # true when the client uses a long string for state.
      # Consider storing a mapping of shorter authz codes to user
      # identifiers in a temporary data store with a short TTL
      def auth_code_for(user, client_id)
        InstAuth::UserToken.for_user(
          user,
          InstAuth::UserToken::PURPOSES.authorization_code,
          client_id:
        )
      end
    end
  end
end
