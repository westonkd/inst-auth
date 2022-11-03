# frozen_string_literal: true

module InstAuth::UserToken
  # TODO: Make a more general JWT module/class

  ALGORITHM = 'HS256'
  AUTHZ_CODE_TTL = 1
  CLAIM_PREFIX = "https://id.instructure.docker"

  PURPOSES = OpenStruct.new(
    authorization_code: 'authorization_code',
    access_token: 'access_token'
  )

  class TokenPurposeMismatchError < StandardError; end

  class << self
    def for_user(user, purpose)
      return nil unless user

      JWT.encode payload(user, purpose), secret, ALGORITHM
    end

    def decode(token, purpose)
      # TODO: Look at this lib to verify it's checking exp, nbf, and jti claims
      #       checking jti is only needed when the purpose is authorization_code.
      #       I think it would be better, however, to cache the values that are
      #       currently nested in the authz code and make the authz code the cahce key.
      # TODO: Add iss and aud verification

      decoded_token = JWT.decode(token, secret, true).first
      token_purpose = decoded_token["#{CLAIM_PREFIX}/purpose"]

      if token_purpose != purpose
        raise TokenPurposeMismatchError, "Expected token to have purpose #{prupose}, but had #{token_purpose}" 
      end

      decoded_token
    end

    private

    def payload(user, purpose)
      tenant = user.tenant

      {
        iss: tenant.tenant_hosts.first.host,
        sub: user.sub,
        aud: ["the Instructure API gateway"],
        iat: Time.now.to_i,
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
          jti: SecureRandom.uuid,
          exp: Time.now.to_i + AUTHZ_CODE_TTL.to_i
        }
      }[purpose]
    end

    def secret
      ENV['SYMMETRIC_TOKEN_SECRET']
    end
  end
end
