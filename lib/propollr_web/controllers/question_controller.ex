defmodule PropollrWeb.QuestionController do
  use PropollrWeb, :controller
  alias Propollr.Questions.Question
  alias Propollr.Repo
  alias Propollr.Sessions.Session

  def answer(conn, %{"answer_params" => answer_params, "session_id" => session_id}) do
    Question.answer(session_id, answer_params)
    conn
    |> put_flash(:info, "Questions Answered")
    |> redirect(to: session_path(conn, :view, session_id: session_id))
  end

  def new(conn, %{"session_id" => session_id}) do
    render(conn, "new.html", session_id: session_id, changeset: Question.changeset(%Question{}, %{}))
  end

  def create(conn, %{"question_params" => question_params, "session_id" => session_id}) do
    text = question_params["text"]

    options =
      question_params
      |> Enum.reject(fn {_k, v} -> v == text end)
      |> Enum.map(fn {_k, v} -> v end)

    answers =
      options
      |> Map.new(fn option -> {option, 0} end)

    changeset =
    session_id
    |> Session.get()
    |> Ecto.build_assoc(:questions, %{text: text, options: options, answers: answers})

    case Repo.insert(changeset) do
      {:ok, _question} ->
        conn
        |> put_flash(:info, "Question Created!")
        |> redirect(to: session_path(conn, :view, session_id: session_id))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> render("new.html", session_id: session_id, changeset: changeset)
    end

  end
end
