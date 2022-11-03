# frozen_string_literal: true

module Security
  class KeySet
    attr_reader :jwk

    def initialize(private_key: nil)
      @jwk = JWT::JWK.import(
        private_key || default_private_key,
        use: :sig,
        alg: 'RS256'
      )
    end

    def jwks
      JWT::JWK::Set.new(@jwk).export
    end

    def signing_key
      @jwk.keypair
    end

    private

    def default_private_key
      JSON.parse(ENV["DEFAULT_PRIVATE_KEY"])
    end
  end
end
