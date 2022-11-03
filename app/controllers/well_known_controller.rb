class WellKnownController < ApplicationController
  def jwks
    # We should explore other ways of exposing these (AWS secretes manager + AWS API Gateway?)
    # IMO each tenant should have their own public/private keyset
    render json: Security::KeySet.new.jwks
  end
end
