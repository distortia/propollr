defmodule PropollrWeb.DashboardController do
  use PropollrWeb, :controller
  alias Propollr.Veil.User
  alias Propollr.Seshes.Sesh

  def index(conn, _params) do
    user = User.get(conn.assigns.veil_user_id)
    opened_seshes = Sesh.get_opened(user.id)
    closed_seshes = Sesh.get_closed(user.id)

    render(conn, "index.html", opened_seshes: opened_seshes, closed_seshes: closed_seshes, user: user)
  end
end
