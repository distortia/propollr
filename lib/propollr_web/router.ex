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
    post "/session/:session_id/close", PageController, :close_session
    post "/session/:session_id/questions/", PageController, :add_question
    get "/session/:session_id/questions", PageController, :all
    get "/session/:session_id/", PageController, :all
    get "/session/:session_id/:question_id", PageController, :view_question
    put "/session/:session_id/:question_id", PageController, :update_question
    delete "/session/:session_id/:question_id", PageController, :delete_question
    post "/session/:session_id/:question_id/answer", PageController, :answer_question

    # Dashboard
    get "/dashboard", DashboardController, :index

    # User
    post "/login", UserController, :login

    # Sessions
    get "/session", SessionController, :view
    post "/session/join", SessionController, :join

    # Questions
    post "/question", QuestionController, :answer
    get "/question", QuestionController, :new
    post "/question/new", QuestionController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", PropollrWeb do
  #   pipe_through :api
  # end
end
