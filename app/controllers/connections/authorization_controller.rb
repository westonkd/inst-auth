module Connections
  class AuthorizationController < ApplicationController
    def authorize
      set_state_cookie
      redirect_to connection.authorization_url, allow_other_host: true
    end

    def callback
      # TODO: handle error response

      # Redirect to a specific tenant if needed
      return redirect_to(tenant_redirect_url, allow_other_host: true) unless params[:redirect_complete]

      connection_from_state = ::Connection.find(decoded_state["#{Security::State::CLAIM_PREFIX}/connection_id"])

      # TODO: Actually do a proper OAuth2 error response
      return head(401) unless Security::State.valid?(
        connection_from_state,
        cookies,
        params[:state]
      )

      # TODO: All the error handling that could occur in this exchange
      connection_helper = Connections::Connection.for_connection(connection_from_state)
      connection_token = connection_helper.token(params[:code])
      user = connection_helper.user_from(connection_token)

      render json: user
    end

    private

    def tenant_redirect_url
      url = URI.parse(connections_callback_path(host: decoded_state['iss']))
      url.query = URI.encode_www_form(redirect_complete: 1, code: params[:code], state: params[:state])
      url.to_s
    end

    def decoded_state
      @decoded_state ||= Security::State.decoded_jwt(params[:state])
    end

    def set_state_cookie
      cookies[connection.cookie_name] = {
        value: connection.cookie_value,
        expires: Security::State::COOKIE_TTL_MINUTES.minute.from_now,
        # importantly, set the domain of the cookie to be readable by the
        # regional tenant. This is the tenant that handles the redirect
        domain: connection_model.tenant.regional_tenant.tenant_hosts.first.host
      }
    end

    def connection_model
      # TODO: Renoamve Connections::Connection to something else :facepalm:
      @connection_model = ::Connection.find_by!(identifier: params[:identifier])
    end

    def connection
      @connection ||= Connections::Connection.for_connection(connection_model)
    end
  end
end
