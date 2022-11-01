# frozen_string_literal: true

module Security::State
  ALGORITHM = 'HS256'

  class << self
    def for_connection(connection)
      JWT.encode payload(connection), secret, ALGORITHM
    end

    private

    def payload(connection)
      { connection_identifier: connection.identifier }
    end

    def secret
      ENV['SYMMETRIC_STATE_SECRET']
    end
  end
end
