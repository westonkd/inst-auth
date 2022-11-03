class GrantTypes::GrantType
  class << self
    class GrantTypeNotFoundError < StandardError; end

    def for_params(token_params)
      return nil if token_params.blank?

      klass = {
        Strategies::Strategy::TYPES.authorization_code => GrantTypes::AuthorizationCode
      }.with_indifferent_access[token_params[:grant_type]]

      raise GrantTypeNotFoundError, "No grant type found for #{token_params[:grant_type]}" if klass.blank?

      klass.new(token_params)
    end
  end

  def initialize(token_params)
    @token_params = token_params
  end

  def valid_request?
    puts "==>", validators
    validators.all? { |v| send(v) }
  end

  def access_token
  end

  def refresh_token
  end

  def id_token
  end

  protected

  def validators
    []
  end
end
