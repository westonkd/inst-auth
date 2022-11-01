module Connections
  class AuthorizationController < ApplicationController
    def authorize
      set_state_cookie
      redirect_to connection.authorization_url, allow_other_host: true
    end

    def callback
      render json: params
    end

    private

    def set_state_cookie
      cookies[connection.cookie_name] = {
        value: connection.cookie_value,
        expires: Security::State::COOKIE_TTL_MINUTES.minute.from_now
      }
    end

    def connection
      @connection ||= Connections::Connection.for_connection(
        ::Connection.find_by!(identifier: params[:identifier])
      )
    end
  end
end
