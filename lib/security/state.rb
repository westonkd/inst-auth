# frozen_string_literal: true

module Security::State
  ALGORITHM = 'HS256'

  # TODO: Make a more general JWT module/class

  COOKIE_TTL_MINUTES = 1
  STATE_TTL_MINUTES = 1
  CLAIM_PREFIX = "https://id.instructure.docker"

  class << self
    def for_connection(connection, client_params = {})
      JWT.encode payload(connection, client_params), secret, ALGORITHM
    end

    def decoded_jwt(token)
      # TODO: Look at this lib to verify it's checking exp, nbf, and jti claims
      # TODO: Add iss and aud verification

      JWT.decode(token, secret, true).first
    end

    def valid?(connection, cookies, state)
      # TODO: remove this line. I just have it here because I've got
      # tenants on different hosts and they cant access cookies properly
      # due to me using ngrok for one of the hosts
      return true

      cookies[Connections::Connection.cookie_name(connection)] ==
        Connections::Connection.cookie_value(state)
    end

    def payload(connection, client_params)
      tenant_host = connection.tenant.tenant_hosts.first.host
      regional_tenant_host = connection.tenant.regional_tenant.tenant_hosts.first.host

      puts puts caller[0..3]

      {
        iss: tenant_host,
        aud: [tenant_host, regional_tenant_host],
        iat: Time.now.to_i,
        exp: Time.now.to_i + STATE_TTL_MINUTES.minutes.to_i,
        "#{CLAIM_PREFIX}/connection_id" => connection.id,
        "#{CLAIM_PREFIX}/client_params" => client_params
      }
    end

    def secret
      ENV['SYMMETRIC_STATE_SECRET']
    end
  end
end
