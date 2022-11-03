# frozen_string_literal: true

module InstAuth::UserToken
  # TODO: Make a more general JWT module/class

  ALGORITHM = 'HS256'
  AUTHZ_CODE_TTL = 60.seconds
  ACCESS_TOKEN_TTL = 60.minutes

  CLAIM_PREFIX = "https://id.instructure.docker"

  KEY_SET = Security::KeySet.new

  PURPOSES = OpenStruct.new(
    authorization_code: 'authorization_code',
    access_token: 'access_token',
    id_token: 'id_token'
  )

  SECRETS = {
    PURPOSES.authorization_code => ENV['SYMMETRIC_TOKEN_SECRET'],
    PURPOSES.access_token => ENV['SYMMETRIC_TOKEN_SECRET'],
    PURPOSES.id_token => KEY_SET.signing_key
  }.freeze

  ALGORITHMS = {
    PURPOSES.authorization_code => "HS256",
    PURPOSES.access_token => "HS256",
    PURPOSES.id_token => "RS256"
  }.freeze

  class TokenPurposeMismatchError < StandardError; end

  class << self
    def for_user(user, purpose, options = {})
      return nil unless user

      JWT.encode(
        payload(user, purpose, options),
        SECRETS[purpose],
        ALGORITHMS[purpose],
        encode_options(purpose)
      )
    end

    def decode(token, purpose)
      # TODO: Look at this lib to verify it's checking exp, nbf, and jti claims
      #       checking jti is only needed when the purpose is authorization_code.
      #       I think it would be better, however, to cache the values that are
      #       currently nested in the authz code and make the authz code the cahce key.
      # TODO: Add iss and aud verification

      decoded_token = JWT.decode(token, SECRETS[purpose], true).first
      token_purpose = decoded_token["#{CLAIM_PREFIX}/purpose"]

      if token_purpose != purpose
        raise TokenPurposeMismatchError, "Expected token to have purpose #{prupose}, but had #{token_purpose}" 
      end

      decoded_token.with_indifferent_access
    end

    private

    def payload(user, purpose, options)
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
        "#{CLAIM_PREFIX}/purpose" => purpose,
        "#{CLAIM_PREFIX}/clientId" => options[:client_id]
      }.merge(purpose_claims(purpose, user, options))
    end

    def purpose_claims(purpose, user, options)
      {
        PURPOSES.authorization_code => {
          jti: SecureRandom.uuid,
          exp: Time.now.to_i + AUTHZ_CODE_TTL.to_i
        },
        PURPOSES.access_token => {
          exp: Time.now.to_i + ACCESS_TOKEN_TTL
        },
        # TODO: Scope these down by the granted scopes
        PURPOSES.id_token => user.as_json.slice(
          "sub",
          "name",
          "given_name",
          "family_name",
          "middle_name",
          "nickname",
          "preferred_username",
          "profile",
          "picture",
          "website",
          "birthdate",
          "zoneinfo",
          "locale",
          "tenant_id"
        ).merge(aud: options[:client_id])
      }[purpose]
    end

    def encode_options(purpose)
      {
        PURPOSES.id_token => {
          kid: KEY_SET.jwk[:kid]
        }
      }[purpose] || {}
    end
  end
end
