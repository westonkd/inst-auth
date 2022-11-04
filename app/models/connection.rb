class Connection < ApplicationRecord
  TYPES = OpenStruct.new({ oauth2: "oauth2" })

  validates(
    :issuer,
    :authorization_endpoint,
    :name,
    :tenant_id,
    :connection_type,
    :identifier,
    :authorization_host,
    presence: true
  )

  # These two validations prevent a tenant from having more than one
  # provider with the same OIDC provider (i.e. you can only have one
  # "Google" connection). Is that really what we want?
  validates :authorization_endpoint, uniqueness: { scope: :issuer }
  validates :identifier, uniqueness: true

  validates :connection_type, inclusion: TYPES.to_h.values

  belongs_to :tenant

  def client_id
    ENV["#{env_key}_CLIENT_ID"]
  end

  def client_secret
    ENV["#{env_key}_CLIENT_SECRET"]
  end

  private

  def env_key
    identifier.upcase
  end
end
