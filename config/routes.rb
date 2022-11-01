Rails.application.routes.draw do
  scope(controller: :authorization) do
    get "/authorize", action: :authorize
  end
end
