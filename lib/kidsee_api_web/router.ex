defmodule KidseeApiWeb.Router do
  use KidseeApiWeb, :router

  pipeline :api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  pipeline :auth do
    plug KidseeApiWeb.Guardian.AuthPipeline
  end

  scope "/api", KidseeApiWeb do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    post "/tokens", TokenController, :create
  end

  scope "/api", KidseeApiWeb do
    pipe_through [:api, :auth]

    resources "/users", UserController, only: [:index, :update, :show, :delete]
  end
end
