defmodule PropollrWeb.SessionController do
  use PropollrWeb, :controller
  alias Propollr.Sessions.Session

    def view(conn, %{"session_id" => session_id}) do
      session = Session.get(session_id)
      conn
      |> render("view.html", session: session)
    end

    def join(conn, %{"session_id" => session_id}) do
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

  def close(conn, %{"session_id" => session_id}) do
    case Session.close(session_id) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Session Closed")
        |> redirect(to: session_path(conn, :view, session_id: session_id))
      {:error, message} ->
        conn
        |> put_flash(:error, "Session unable to close - " <> message)
        |> redirect(to: session_path(conn, :view, sesison_id: session_id))
        |> halt()
    end
  end

  def reopen(conn, %{"session_id" => session_id}) do
    case Session.reopen(session_id) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Session Reopened")
        |> redirect(to: session_path(conn, :view, session_id: session_id))
      {:error, message} ->
        conn
        |> put_flash(:error, "Session unable to reopen - " <> message)
        |> redirect(to: session_path(conn, :view, sesison_id: session_id))
        |> halt()
    end
  end
end
