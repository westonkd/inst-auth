module Serializers
  class ConnectionsSerializer
    def initialize(connections)
      @connections = connections
    end

    def as_json(_options = nil)
      @connections.map do |connection|
        ConnectionSerializer.new(connection).as_json
      end.as_json
    end
  end
end
