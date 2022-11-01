module Connections
  class Canvas < Connection
    protected

    def client_id
      ENV['CANVAS_CLIENT_ID']
    end

    def client_secret
      ENV['CANVAS_CLIENT_SECRET']
    end
  end
end
