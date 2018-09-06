defmodule PropollrWeb.Router do
  use PropollrWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(PropollrWeb.Plugs.Veil.UserId)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", PropollrWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    post("/feedback", PageController, :feedback)
    post("/newsletter", PageController, :newsletter)
    post("/contact", PageController, :contact)

    # Sessions
    get("/sesh", SeshController, :view)
    post("/sesh/join", SeshController, :join)
    get("/sesh/join/:sesh_id", SeshController, :join)

    get("/sesh/new", SeshController, :new)
    get("/sesh/new/soft", SeshController, :new_soft)
    post("/sesh/new", SeshController, :create)
    post("/sesh/new/soft", SeshController, :create_soft)

    # Questions
    post("/question", QuestionController, :answer)
  end

  # Other scopes may use custom stacks.
  # scope "/api", PropollrWeb do
  #   pipe_through :api
  # end

  # Default Routes for Veil
  scope "/veil", PropollrWeb.Veil do
    pipe_through(:browser)

    post("/users", UserController, :create)

    get("/users/new", UserController, :new)
    get("/sessions/new/:request_id", SessionController, :create)
    get("/sessions/signout/:session_id", SessionController, :delete)
  end

  # Add your routes that require authentication in this block.
  # Alternatively, you can use the default block and authenticate in the controllers.
  # See the Veil README for more.
  scope "/", PropollrWeb do
    pipe_through([:browser, PropollrWeb.Plugs.Veil.Authenticate])
    # Dashboard
    get("/dashboard", DashboardController, :index)

    # Seshes
    get("/sesh/close", SeshController, :close)
    get("/sesh/reopen", SeshController, :reopen)
    get("/sesh/edit", SeshController, :edit)
    put("/sesh/edit", SeshController, :update)

    # Questions
    get("/question", QuestionController, :new)
    post("/question/new", QuestionController, :create)
    get("/quesiton/edit", QuestionController, :edit)
    put("/question", QuestionController, :update)
    delete("/question", QuestionController, :delete)
  end
end
