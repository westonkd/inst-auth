# frozen_string_literal: true

module Connections
  class Canvas < Connection
    IDENTIFIER = 'canvas_lms'

    def user_for(token)
      {}
    end

    protected

    def client_id
      ENV['CANVAS_CLIENT_ID']
    end

    def client_secret
      ENV['CANVAS_CLIENT_SECRET']
    end
  end
end
