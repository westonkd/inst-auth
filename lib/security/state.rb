# frozen_string_literal: true

module Security::State
  ALGORITHM = 'HS256'
  COOKIE_TTL_MINUTES = 1

  class << self
    def for_connection(connection)
      JWT.encode payload(connection), secret, ALGORITHM
    end

    private

    def payload(connection)
      { tenant: connection.tenant.regional_tenant.id }
    end

    def secret
      ENV['SYMMETRIC_STATE_SECRET']
    end
  end
end
