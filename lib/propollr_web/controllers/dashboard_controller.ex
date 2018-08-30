defmodule PropollrWeb.DashboardController do
  use PropollrWeb, :controller
  alias Propollr.Users.User
  alias Propollr.Sessions.Session
  def index(conn, _params) do
    user = get_session(conn, :user)
    opened_sessions = Session.get_opened(user.id)
    closed_sessions = Session.get_closed(user.id)
    conn
    |> put_session(:user, user)
    render(conn, "index.html", opened_sessions: opened_sessions, closed_sessions: closed_sessions, user: user)
  end
end
