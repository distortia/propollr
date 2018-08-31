defmodule PropollrWeb.SeshView do
  use PropollrWeb, :view
  alias Propollr.Repo
  alias Propollr.Veil.User

  def user_belongs_to_session?(conn) do
    case conn.assigns[:user] do
      nil ->
        false
      user ->
        Enum.any?(user.seshes, fn sesh ->
          sesh.sesh_id == conn.query_params["sesh_id"]
        end)
    end
  end
end
