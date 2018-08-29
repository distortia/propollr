defmodule PropollrWeb.LayoutView do
  use PropollrWeb, :view

  def active_class(conn, path, passthrough_classes) do
    current_path = Path.join(["/" | conn.path_info])
    if path == current_path, do: passthrough_classes <> " is-active", else: passthrough_classes
  end
end
