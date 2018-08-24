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

  def join(conn, %{"session_params" => session_params}) do
    random_user_id = get_session(conn, :random_user_id)

    session_id = session_params["session_id"]
    case session_valid?(session_id) do
      {:ok, session} ->
        if session.user.random_user_id == random_user_id do
          conn
          |> put_flash(:info, "Rejoining your session")
              |> render("new.html", session_id: session_id, questions: session.questions, changeset: Question.changeset(%Question{}, %{}))
        else
          conn
          |> put_flash(:info, "Session Joined!")
          |> render("all.html", session: session, questions: session.questions)
        end
    {:error, :invalid_session} ->
      conn
      |> put_flash(:error, "There is no session available, or session has closed for #{session_id}.")
      |> render("index.html")
    end
  end

  def add_question(conn, %{"session_id" => session_id, "question" => question}) do
    question =
    question
    |> format_question_params()

    Session
    |> Repo.get_by(session_id: session_id)
    |> Ecto.build_assoc(:questions, question)
    |> Repo.insert()

    session = Session.with_questions(session_id)
    conn
    |> put_flash(:info, "Question Added!")
    |> render("new.html", session_id: session_id, questions: session.questions, changeset: Question.changeset(%Question{}, %{}))
  end

  def format_question_params(question_params) do
    %{
      text: question_params["text"],
      options:
        Map.delete(question_params, "text")
        |> Enum.map(fn {_k,v} -> v end),
      answers: %{}
    }
  end

  def all(conn, %{"session_id" => session_id}) do
    session = Session.with_questions(session_id)
    render("all.html", session: session, questions: session.questions)
  end

  defp session_valid?(session_id) do
    case Session.with_questions(session_id) do
      nil -> {:error, :invalid_session}
      session -> {:ok, session}
    end
  end
end
