module Serializers
  class ConnectionSerializer
    def initialize(connection)
      @connection = connection
    end

    def as_json(_options = nil)
      {
        name: @connection.name,
        identifier: @connection.identifier,
        authorization_url: authorization_url(@connection)
      }
    end

    private

    def authorization_url(connection)
      Rails.application.routes.url_helpers.connections_authorization_url(
        host: connection.tenant.tenant_hosts.first.host,
        identifier: connection.identifier
      )
    end
  end
end
