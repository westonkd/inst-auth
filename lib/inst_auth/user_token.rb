# frozen_string_literal: true

module InstAuth::UserToken
  # TODO: Make a more general JWT module/class

  ALGORITHM = 'HS256'
  STATE_TTL = 60
  CLAIM_PREFIX = "https://id.instructure.docker"

  PURPOSES = OpenStruct.new(
    authorization_code: 'authorization_code',
    access_token: 'access_token'
  )

  class << self
    def for_user(user, purpose)
      return nil unless user

      JWT.encode payload(user, purpose), secret, ALGORITHM
    end

    private

    def payload(user, purpose)
      tenant = user.tenant

      {
        iss: tenant.tenant_hosts.first.host,
        sub: user.sub,
        aud: ["the Instructure API gateway"],
        iat: Time.now.to_i,
        exp: Time.now.to_i + STATE_TTL.minutes.to_i,
        # TODO: Dynamically discover provider's scopes via a .well-known
        # endpoint that each exposes. Clients can then set scopes in the
        # authz/token requests and have them added here.
        scopes: [],
        "#{CLAIM_PREFIX}/purpose" => purpose
      }.merge(purpose_claims(purpose))
    end

    def purpose_claims(purpose)
      {
        PURPOSES.authorization_code => {
          jti: SecureRandom.uuid
        }
      }[purpose]
    end

    def secret
      ENV['SYMMETRIC_TOKEN_SECRET']
    end
  end
end
