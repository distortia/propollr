defmodule PropollrWeb.SeshController do
  use PropollrWeb, :controller
  alias Propollr.Seshes.Sesh
  alias Propollr.Veil.User

  def view(conn, %{"sesh_id" => sesh_id}) do
    user = User.get(conn.assigns.veil_user_id)
    sesh = Sesh.get_by(sesh_id)

    conn
    |> put_session(:sesh_id, sesh.sesh_id)
    |> render("view.html", sesh: sesh, user: user)
  end

  def join(conn, %{"sesh_id" => sesh_id}) do
    sesh = Sesh.get_by(sesh_id)

    case sesh do
      nil ->
        conn
        |> put_flash(:error, "No session with the ID " <> sesh_id <> " exists or is open.")
        |> redirect(to: page_path(conn, :index))

      _ ->
        conn
        |> put_session(:sesh_id, sesh.sesh_id)
        |> render("view.html", sesh: sesh)
    end
  end

  def join(conn, params) do
    sesh_id = params["sesh_id"]
    sesh = Sesh.get_by(sesh_id)

    case sesh do
      nil ->
        conn
        |> put_flash(:error, "No Sesh with the ID " <> sesh_id <> " exists or is open.")
        |> redirect(to: page_path(conn, :index))

      _ ->
        conn
        |> put_session(:sesh_id, sesh.sesh_id)
        |> render("view.html", sesh: sesh)
    end
  end

  def close(conn, %{"sesh_id" => sesh_id}) do
    case Sesh.close(sesh_id) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Sesh Closed")
        |> redirect(to: sesh_path(conn, :view, sesh_id: sesh_id))

      {:error, message} ->
        conn
        |> put_flash(:error, "Sesh unable to close - " <> message)
        |> redirect(to: sesh_path(conn, :view, sesh_id: sesh_id))
        |> halt()
    end
  end

  def reopen(conn, %{"sesh_id" => sesh_id}) do
    case Sesh.reopen(sesh_id) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Sesh Reopened")
        |> redirect(to: sesh_path(conn, :view, sesh_id: sesh_id))

      {:error, message} ->
        conn
        |> put_flash(:error, "Sesh unable to reopen - " <> message)
        |> redirect(to: sesh_path(conn, :view, sesison_id: sesh_id))
        |> halt()
    end
  end

  def new(conn, _params) do
    user = User.get(conn.assigns.veil_user_id)

    changeset =
      user
      |> Ecto.build_assoc(:seshes, %Sesh{})
      |> Sesh.changeset(%{})

    render(conn, "new.html", changeset: changeset, user: user)
  end

  def new_soft(conn, _params) do
    render(conn, "new_soft.html", changeset: Sesh.changeset(%Sesh{}, %{}))
  end

  def create(conn, %{"sesh_params" => sesh_params}) do
    user = User.get(conn.assigns.veil_user_id)

    case Sesh.create(user, sesh_params) do
      {:ok, sesh} ->
        conn
        |> put_flash(:info, "Sesh Created!")
        |> redirect(to: sesh_path(conn, :view, sesh_id: sesh.sesh_id))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error creating session")
        |> render("new.html", changeset: changeset)
        |> halt()
    end
  end

  def edit(conn, %{"sesh_id" => sesh_id}) do
    sesh =
      sesh_id
      |> Sesh.get_by()

    changeset =
      sesh
      |> Sesh.changeset(%{})

    render(conn, "edit.html", changeset: changeset, sesh_id: sesh_id, questions: sesh.questions)
  end

  def update(conn, %{"sesh_id" => sesh_id, "sesh_params" => sesh_params}) do
    case Sesh.update(sesh_id, sesh_params) do
      {:ok, sesh} ->
        user = sesh.user_id |> User.get()

        conn
        |> put_flash(:info, "Sesh Updated")
        |> redirect(to: sesh_path(conn, :view, sesh_id: sesh_id, user: user))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error when updating. Please try again")
        |> render("edit.html", changeset: changeset)
        |> halt()
    end
  end
end
