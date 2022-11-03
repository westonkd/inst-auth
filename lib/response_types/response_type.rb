module ResponseTypes
  class ResponseType
    class ResponseTypeNotFound < StandardError; end

    TYPES = OpenStruct.new(authorization_code: :authorization_code)

    class << self
      def for(response_type)
        {
          TYPES.authorization_code => AuthorizationCode,
          # TODO: store as a constant
          'code' => AuthorizationCode
        }.with_indifferent_access[response_type] || (raise ResponseTypeNotFound, "Could not find responste type for #{startegy_type}")
      end

      def client_for_connection(connection)
        # I'm not a huge fan of this library. I would consider using somethingi
        # else or writting the bits it does not support from scratch (PKCE, etc)
        OAuth2::Client.new(
          connection.client_id,
          connection.client_secret,
          site: connection.issuer, # /This should actually be the actual host
          authorize_url: connection.authorization_endpoint,
          token_url: connection.token_endpoint
        )
      end
    end
  end
end
