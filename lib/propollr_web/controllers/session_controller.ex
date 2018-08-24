defmodule PropollrWeb.SessionController do
  use PropollrWeb, :controller
  alias Propollr.Sessions.Session

    def view(conn, %{"session_id" => session_id}) do
      session = Session.get(session_id)
      conn
      |> render("view.html", session: session)
    end

    def join(conn, params) do
      session_id = params["session_id"]
      session = Session.get_by(session_id)
      case session do
        nil ->
          conn
          |> put_flash(:error, "No Session with the ID " <> session_id <> " exists or is open.")
          |> redirect(to: page_path(conn, :index))
        _ ->
          conn
          |> render("view.html", session: session)
      end
    end
end
