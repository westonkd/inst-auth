module GrantTypes
  class AuthorizationCode < GrantTypes::GrantType
    def initialize(token_params)
      super(token_params)

      @decoded_code = decoded_code
      @application = Application.find_by(client_id: token_params[:client_id])
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
