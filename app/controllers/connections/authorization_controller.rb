module Connections
  class AuthorizationController < ApplicationController
    include Connections::Authorize
    include Connections::Callback

    def authorize
      set_state_cookie

      redirect_to(
        connection.authorization_url(client_params:),
        allow_other_host: true
      )
    end

    def callback
      # TODO: handle error response

      # Redirect to a specific tenant if needed
      return redirect_to_target_tenant unless params[:redirect_complete]

      # TODO: Actually do a proper OAuth2 error response
      return head(401) unless valid_state_cookie?

      redirect_to(
        original_callback_url,
        allow_other_host: true
      )
    end
  end
end
