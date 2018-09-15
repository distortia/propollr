defmodule PropollrWeb.BreadcrumbHelper do
  use Phoenix.HTML
  import PropollrWeb.Gettext
  import PropollrWeb.Router.Helpers

  def breadcrumbs(args) do
    content_tag(:nav, class: "breadcrumb") do
      content_tag(:ul) do
        __MODULE__
        |> apply(:crumbs, args)
        |> render()
      end
    end
  end

  def crumbs(conn, :dashboard) do
    [{gettext("Dashboard"), dashboard_path(conn, :index)}]
  end

  def crumbs(conn, :sesh, sesh_id) do
    [{gettext("Sesh"), sesh_path(conn, :view, sesh_id: sesh_id)} | crumbs(conn, :dashboard)]
  end

  def crumbs(conn, :sesh_edit, sesh_id) do
    [{gettext("Edit Sesh"), sesh_path(conn, :edit, sesh_id: sesh_id)} | crumbs(conn, :sesh, sesh_id)]
  end

  def crumbs(conn, :new_question, sesh_id) do
    [{gettext("New Question"), question_path(conn, :new)} | crumbs(conn, :sesh, sesh_id)]
  end

  def crumbs(conn, :edit_question, sesh_id) do
    [{gettext("Edit Question"), question_path(conn, :edit)} | crumbs(conn, :sesh_edit, sesh_id)]
  end

  defp render([current | tail]) do
    ([render_crumb(current, :current)] ++ Enum.map(tail, &render_crumb(&1)) |> Enum.reverse())
  end

  defp render_crumb({text, _path}, :current) do
    content_tag :li, class: "is-active" do
      content_tag :a, do: text
    end
  end

  defp render_crumb({text, path}) do
    content_tag :li do
      link(text, to: path)
    end
  end

end
