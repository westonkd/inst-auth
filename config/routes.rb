Rails.application.routes.draw do
  scope(controller: :authorization) do
    get "/authorize", action: :authorize
  end

  scope(controller: 'connections/authorization') do
    get "/connections/:identifier/authorize", action: :authorize
    get "/connections/callback", action: :callback
  end
end
