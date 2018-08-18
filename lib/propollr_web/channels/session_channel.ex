defmodule PropollrWeb.SessionChannel do
  use Phoenix.Channel

  def join("session:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("session" <> session_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end