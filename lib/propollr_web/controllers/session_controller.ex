defmodule PropollrWeb.SessionController do
  use PropollrWeb, :controller
  alias Propollr.Sessions.Session
  alias Propollr.Users.User

  def view(conn, %{"session_id" => session_id}) do
    user = 
    conn
    |> get_session(:user_id)
    |> User.get()
    session = Session.get_by(session_id)
    conn
    |> put_session(:session_id, session.session_id)
    |> render("view.html", session: session, user: user)
  end

  def join(conn, %{"session_id" => session_id}) do
    session = Session.get_by(session_id)
    case session do
      nil ->
        conn
        |> put_flash(:error, "No Session with the ID " <> session_id <> " exists or is open.")
        |> redirect(to: page_path(conn, :index))
      _ ->
        conn
        |> put_session(:session_id, session.session_id)
        |> render("view.html", session: session)
    end
  end

  def join(conn, params) do
    session_id = params["session_id"]
    session = Session.get_by(session_id)
    case session do
      nil ->
        conn
        |> put_flash(:error, "No Session with the ID " <> session_id <> " exists or is open.")
        |> redirect(to: page_path(conn, :index))
      _ ->
        conn
        |> put_session(:session_id, session.session_id)
        |> render("view.html", session: session)
    end
  end

  def close(conn, %{"session_id" => session_id}) do
    case Session.close(session_id) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Session Closed")
        |> redirect(to: session_path(conn, :view, session_id: session_id))
      {:error, message} ->
        conn
        |> put_flash(:error, "Session unable to close - " <> message)
        |> redirect(to: session_path(conn, :view, sesison_id: session_id))
        |> halt()
    end
  end

  def reopen(conn, %{"session_id" => session_id}) do
    case Session.reopen(session_id) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Session Reopened")
        |> redirect(to: session_path(conn, :view, session_id: session_id))
      {:error, message} ->
        conn
        |> put_flash(:error, "Session unable to reopen - " <> message)
        |> redirect(to: session_path(conn, :view, sesison_id: session_id))
        |> halt()
    end
  end

  def new(conn, _params) do
    user =
    conn
    |> get_session(:user_id)
    |> User.get()
    changeset =
      user
      |> Ecto.build_assoc(:sessions, %Session{})
      |> Session.changeset(%{})
    render(conn, "new.html", changeset: changeset, user: user)
  end

  def new_soft(conn, _params) do
    render(conn, "new_soft.html", changeset: Session.changeset(%Session{}, %{}))
  end

  def create(conn, %{"session_params" => session_params}) do
    user =
    conn
    |> get_session(:user_id)
    |> User.get()

    case Session.create(user, session_params) do
      {:ok, session} ->
        conn
        |> put_flash(:info, "Session Created!")
        |> redirect(to: session_path(conn, :view, session_id: session.session_id))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error creating session")
        |> render("new.html", changeset: changeset)
        |> halt()  
    end
  end

  def create_soft(conn, %{"session_params" => session_params}) do
    user = 
    Ecto.UUID.generate()
    |> binary_part(16,16)
    |> User.soft_user()
    session = Session.soft_session(session_params, user)
    conn
    |> put_flash(:info, "Session Created!")
    |> put_session(:user_id, user.id)
    |> redirect(to: session_path(conn, :view, session_id: session.session_id))
  end

  def edit(conn, %{"session_id" => session_id}) do
    session = 
      session_id
      |> Session.get_by()
    changeset =
      session
      |> Session.changeset(%{})
    render(conn, "edit.html", changeset: changeset, session_id: session_id, questions: session.questions)
  end

  def update(conn, %{"session_id" => session_id, "session_params" => session_params}) do
    case Session.update(session_id, session_params) do
      {:ok, session} ->
        user = session.user_id |> User.get()
        conn
        |> put_flash(:info, "Session Updated")
        |> redirect(to: session_path(conn, :view, session_id: session_id, user: user))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error when updating. Please try again")
        |> render("edit.html", changeset: changeset)
        |> halt()
    end
  end
end
