defmodule PropollrWeb.DashboardController do
  use PropollrWeb, :controller
  alias Propollr.Users.User
  alias Propollr.Sessions.Session
  def index(conn, _params) do
    user = 
    conn
    |> get_session(:user_id)
    |> User.get()
    opened_sessions = Session.get_opened(user.id)
    closed_sessions = Session.get_closed(user.id)
    conn
    |> render("index.html", opened_sessions: opened_sessions, closed_sessions: closed_sessions, user: user)
  end
end
