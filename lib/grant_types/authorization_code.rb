module GrantTypes
  class AuthorizationCode < GrantTypes::GrantType
    def initialize(token_params)
      super(token_params)

      @decoded_code = decoded_code
      @application = Application.find_by(client_id: token_params[:client_id])
      @user = User.find_by(sub: @decoded_code[:sub])
    end

    def tokens
      {
        access_token:,
        refresh_token:,
        id_token:
      }.compact
    end

    protected

    def validators
      %i[
        client_secret_valid?
        redirect_uri_valid?
        scope_valid?
        code_valid?
      ]
    end

    private

    def access_token
      InstAuth::UserToken.for_user(
        @user,
        InstAuth::UserToken::PURPOSES.access_token,
        client_id: @token_params[:client_id]
      )
    end

    def refresh_token
      # TODO: Refresh tokens. I kind of like the idea of return a new refresh token
      # every time a refresh occurs. That refresh token could have an "exp" that gets
      # persisted between refresh tokens at refresh time. That would allow us to for_connection
      # an application to let the user re-login if desired. This should be configurable
    end

    def id_token
    end

    def client_secret_valid?
      return false unless @application.present?
      return false if @application.client_secret != @token_params[:client_secret]

      true
    end

    def redirect_uri_valid?
      return false unless @application.redirect_uris.include? @token_params[:redirect_uri]

      true
    end

    def scope_valid?
      # TODO: Use the code to verify the requested scopes were granted

      true
    end

    def code_valid?
      @decoded_code.present?

      true
    end

    def decoded_code
      InstAuth::UserToken.decode(
        @token_params[:code],
        InstAuth::UserToken::PURPOSES.authorization_code
      )
    end
  end
end
