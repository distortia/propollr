defmodule PropollrWeb.PageController do
  use PropollrWeb, :controller
  alias Propollr.Questions.Question
  alias Propollr.Users.User
  alias Propollr.Sessions.Session
  import Ecto.Query

  def index(conn, _params) do
    render conn, "index.html"
  end

  def new(conn, _params) do
    session = Session.new()
    session_id = session.session_id
    conn
    |> put_flash(:info, "New Session created! Here is your session id " <> session_id)
    |> render("new.html", session_id: session_id, changeset: Question.changeset(%Question{}, %{}))
  end

  def join(conn, %{"session_params" => session_params}) do
    session_id = session_params["session_id"]
    if session_valid?(session_id) do
      conn
      |> put_flash(:info, "Session Joined!")
      |> render("session.html", session_id: session_id)
    else
      conn
      |> put_flash(:error, "There is no session available, or session has closed for #{session_id}.")
      |> render("index.html")
    end
  end

  def add_question(conn, %{"session_id" => session_id, "question" => question}) do
    question =
    question
    |> format_question_params()

    %Session{}
    |> Ecto.build_assoc(:questions, question)
    |> IO.inspect()

    redirect(conn, to: "/session/#{session_id}/questions/")
  end

  defp format_question_params(question_params) do
    %{
      text: question_params["text"],
      options: Map.delete(question_params, "text"),
      answers: %{}
    }
  end

  def all(conn, %{"session_id" => session_id}) do
    questions = Session.with_questions(session_id)
    render("all.html", questions: questions)
  end

  defp session_valid?(_session_id) do
    false
  end

end
