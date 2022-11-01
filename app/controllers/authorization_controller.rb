class AuthorizationController < ApplicationController
  def authorize
    render locals: { props: authorize_props }
  end

  private

  def authorize_props
    {
      tenant: current_tenant.name,
      connections: current_tenant.connections
    }
  end
end
