class TokenController < ApplicationController
  include Authorization

  skip_before_action :verify_authenticity_token, only: :token

  def token
    # TODO: A standards-compliant error response
    return head 401 unless grant_type.valid_request?

    render json: {}
  end

  private

  def grant_type
    @grant_type ||= GrantTypes::GrantType.for_params(params)
  end
end
