# frozen_string_literal: true

module Connections
  class Canvas < Connection
    IDENTIFIER = 'canvas_lms'

    def user_from(token)
      userinfo(token)
    end

    protected

    def client_id
      ENV['CANVAS_CLIENT_ID']
    end

    def client_secret
      ENV['CANVAS_CLIENT_SECRET']
    end

    private

    def make_request(path, token)
      HTTParty.get(
        "#{@connection.authorization_host}#{path}",
        headers: { Authorization: "Bearer #{token}" }
      )
    end

    def userinfo(token)
      # TODO: Support real uerinfo in Canvas ;)
      make_request("/api/v1/users/self", token)
    end
  end
end
