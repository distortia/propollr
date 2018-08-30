defmodule PropollrWeb.UserController do
  use PropollrWeb, :controller
  alias Propollr.Users.User

  def login(conn, %{"username" => username, "password" => password}) do
    if username == "nick" && password == "123" do
     user = User.get_by_username(username)
      conn
      |> put_flash(:info, "Successfully Logged In!")
      |> put_session(:user_id, user.id)
      |> redirect(to: dashboard_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Invalid Username or Password")
      |> redirect(to: "/")
      |> halt()
    end
  end
end
