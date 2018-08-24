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

    # Dashboard
    get "/dashboard", DashboardController, :index

    # User
    post "/login", UserController, :login

    # Sessions
    get "/session", SessionController, :view
    post "/session/join", SessionController, :join
    get "/session/join/:session_id", SessionController, :join
    get "/session/close", SessionController, :close
    get "/session/reopen", SessionController, :reopen

    # Questions
    post "/question", QuestionController, :answer
    get "/question", QuestionController, :new
    post "/question/new", QuestionController, :create
    get "/question/view", QuestionController, :view
    get "/quesiton/edit", QuestionController, :edit
    put "/question", QuestionController, :update
    delete "/question", QuestionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", PropollrWeb do
  #   pipe_through :api
  # end
end
