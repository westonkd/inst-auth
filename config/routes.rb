Rails.application.routes.draw do
  scope(controller: :authorization) do
    get "/authorize", action: :authorize
  end

  scope(controller: :token) do
    post "/token", action: :token
  end

  scope(controller: 'connections/authorization') do
    get "/connections/:identifier/authorize", action: :authorize, as: "connections_authorization"
    get "/connections/callback", action: :callback
  end
end
