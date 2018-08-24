defmodule PropollrWeb.PageController do
  use PropollrWeb, :controller
  alias Propollr.Questions.Question
  alias Propollr.Users.User
  alias Propollr.Sessions.Session
  alias Propollr.Repo
  import Ecto.Query

  def index(conn, _params) do
    conn = put_session(conn, :random_user_id, Ecto.UUID.generate |> binary_part(16,16))
    render conn, "index.html"
  end

  def new(conn, _params) do
    random_user_id = get_session(conn, :random_user_id)
    session = Session.new(random_user_id)
    session_id = session.session_id
    conn
    |> put_flash(:info, "New Session created! Here is your session id " <> session_id)
    |> render("new.html", session_id: session_id, questions: [], changeset: Question.changeset(%Question{}, %{}))
  end
end
