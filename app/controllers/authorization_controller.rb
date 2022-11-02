class AuthorizationController < ApplicationController
  include Authorization

  rescue_from AuthorizationError do |exception|
    # TODO: Do spec-compliant error responses
    render json: exception, status: 401
  end

  before_action :validate_redirect_uris, :validate_response_type, :validate_scope, only: :authorize

  def authorize
    render locals: { props: authorize_props }
  end

  private

  def authorize_props
    # TODO: It would be much nicer to store these values with an unique cache key
    # rather than piping them around via params and nested in the state JWT
    {
      tenant: current_tenant.name,
      connections: Serializers::ConnectionsSerializer.new(current_tenant.connections),
      client_state: params[:state],
      client_id: params[:client_id],
      client_redirect_uri: params[:redirect_uri],
      client_response_type: params[:response_type]
    }
  end
end
