defmodule PropollrWeb.PageController do
  use PropollrWeb, :controller
  alias Propollr.Questions.Question
  alias Propollr.Users.User
  alias Propollr.Sessions.Session
  alias Propollr.Repo
  import Ecto.Query

  def index(conn, _params) do
    render conn, "index.html"
  end
end
