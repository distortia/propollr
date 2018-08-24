defmodule PropollrWeb.DashboardController do
  use PropollrWeb, :controller
  alias Propollr.Users.User

  def index(conn, _params) do
    user = get_session(conn, :user)
    render(conn, "index.html", sessions: user.sessions, user: user)
  end
end
