defmodule PropollrWeb.Router do
  use PropollrWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PropollrWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/new_session", PageController, :new
    post "/join_session", PageController, :join
  end

  # Other scopes may use custom stacks.
  # scope "/api", PropollrWeb do
  #   pipe_through :api
  # end
end
