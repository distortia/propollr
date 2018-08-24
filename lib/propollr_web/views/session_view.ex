defmodule PropollrWeb.SessionView do
  use PropollrWeb, :view

  def is_user(conn) do
    if Plug.Conn.get_session(conn, :user), do: true, else: false
  end
end
