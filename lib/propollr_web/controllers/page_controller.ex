defmodule PropollrWeb.PageController do
  use PropollrWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
