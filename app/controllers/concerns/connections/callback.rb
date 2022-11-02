module Connections::Callback
  extend ActiveSupport::Concern

  # TODO: Better organize this random collection of methods :)

  def valid_state_cookie?
    Security::State.valid?(
      connection_from_state,
      cookies,
      params[:state]
    )
  end

  def redirect_to_target_tenant
    redirect_to(tenant_redirect_url, allow_other_host: true)
  end

  def user
    # TODO: All the error handling that could occur in this exchange
    connection_helper = Connections::Connection.for_connection(connection_from_state)
    connection_token = connection_helper.token(params[:code])
    connection_helper.user_for(connection_token)
  end

  def original_params
    @original_params ||= decoded_state["#{Security::State::CLAIM_PREFIX}/client_params"]
  end

  def callback_strategy
    @callback_strategy ||= Strategies::Strategy.for(original_params["client_response_type"])
  end

  def original_callback_url
    # TODO: We already check the redirect URI is valid before writing it to the state token
    # Can I think of any vectors that could take advantage of leaving out an additional check here?
    callback_strategy.redirect_uri(user, original_params["client_state"], original_params["client_redirecet_uri"])
  end

  def decoded_state
    @decoded_state ||= Security::State.decoded_jwt(params[:state])
  end

  def connection_from_state
    ::Connection.find(decoded_state["#{Security::State::CLAIM_PREFIX}/connection_id"])
  end

  def tenant_redirect_url
    url = URI.parse(connections_callback_path(host: decoded_state['iss']))
    url.query = URI.encode_www_form(redirect_complete: 1, code: params[:code], state: params[:state])
    url.to_s
  end
end
