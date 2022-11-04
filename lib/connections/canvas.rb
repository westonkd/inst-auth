# frozen_string_literal: true

module Connections
  class Canvas < Connection
    IDENTIFIER = 'canvas_lms'

    def user_for(token)
      user_from_info(userinfo(token))
    end

    private

    def make_request(path, token)
      HTTParty.get(
        "#{@connection.authorization_host}#{path}?include[]=uuid",
        headers: { Authorization: "Bearer #{token}" }
      )
    end

    def user_from_info(userinfo)
      # TODO: Be a little smarter about looking up users. If
      # a user already exist with the same email, probably join
      # them.
      user = @connection.tenant.users.find_or_initialize_by(
        sub: @connection.user_identifier(userinfo[:uuid])
      )

      user.update!(
        name: userinfo[:name],
        picture: userinfo[:avatar_url],
        locale: userinfo[:effective_locale]
      )

      user.communication_channels.find_or_create_by!(
        path_type: 'email',
        path: userinfo[:email],
        # TODO: check the channel's state in Canvas. Better yet,
        # add a spec-compliant userinfo endpoint to Canvas
        workflow_state: 'verified'
      )

      user
    end

    def userinfo(token)
      # TODO: Support real uerinfo in Canvas ;)
      make_request("/api/v1/users/self", token).with_indifferent_access
    end
  end
end
