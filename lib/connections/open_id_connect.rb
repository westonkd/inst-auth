# frozen_string_literal: true

module Connections
  class OpenIdConnect < Connection
    IDENTIFIER = 'oidc'

    def user_for(token)
      # TODO: This is OIDC, we should really just
      # parse and validate the id_token rather than
      # rely on userinfo ;)
      user_from_info(userinfo(token))
    end

    private

    def user_from_info(info)
      # TODO: Be a little smarter about lojoking up users. If
      # a user already exist with the same email, probably join
      # them.
      user = @connection.tenant.users.find_or_initialize_by(
        sub: @connection.user_identifier(info[:sub])
      )

      user.update!(
        name: info[:name],
        picture: info[:picture],
        locale: info[:locale]
      )

      user.communication_channels.find_or_create_by!(
        path_type: 'email',
        path: info[:email],
        workflow_state: info[:email_verified] ? "verified" : "unverified"
      )

      user
    end

    def make_request(url, token)
      HTTParty.get(
        url,
        headers: { Authorization: "Bearer #{token}" }
      )
    end

    def userinfo(token)
      make_request(@connection.userinfo_endpoint, token).with_indifferent_access
    end
  end
end
