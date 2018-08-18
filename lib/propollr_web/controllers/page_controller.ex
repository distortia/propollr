defmodule PropollrWeb.PageController do
  use PropollrWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def new(conn, _params) do
    session_id = randomize_session_id()
    conn
    |> put_flash(:info, "New Session created! Here is your session id " <> session_id)
    |> render("new.html", session_id: session_id)
  end

  def join(conn, %{"session_params" => session_params}) do
    session_id = session_params["session_id"]
    if session_valid?(session_id) do
      conn
      |> put_flash(:info, "Session Joined!")
      |> render("session.html", session_id: session_id)
    else
      conn
      |> put_flash(:error, "There is no session available, or session has closed for #{session_id}.")
      |> render("index.html")
    end
  end

  defp session_valid?(_session_id) do
    false
  end

  defp randomize_session_id() do
    Ecto.UUID.generate |> binary_part(16,16)
  end
end
