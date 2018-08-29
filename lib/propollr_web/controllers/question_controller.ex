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
    conn
    |> put_session(:session_id, session_id)
    |> render("new.html", session_id: session_id, changeset: Question.changeset(%Question{}, %{}))
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
      {:ok, question} ->
        # Broadcast to the channel that theres a new question
        payload = %{question_id: question.id, text: question.text, options: question.options, answers: question.answers}
        PropollrWeb.Endpoint.broadcast("session:#{session_id}", "new_question", payload)
        conn
        |> put_flash(:info, "Question Created!")
        |> redirect(to: session_path(conn, :view, session_id: session_id))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> render("new.html", session_id: session_id, changeset: changeset)
    end

  end

  def view(conn, %{"question_id" => question_id}) do
    render(conn, "view.html", question: Question.get(question_id))
  end

  def edit(conn, %{"question_id" => question_id}) do
    changeset =
      question_id
      |> Question.get()
      |> Question.changeset(%{})
    render(conn, "edit.html", changeset: changeset, question: Question.get(question_id))
  end

  def update(conn, %{"question_id" => question_id, "question_params" => question_params}) do
    case Question.update(question_id, format_question_params(question_params)) do
      {:ok, question} ->
        conn
        |> put_flash(:info, "Question Updated")
        |> redirect(to: session_path(conn, :view, session_id: question.session_id))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Unable to update question.")
        |> render("edit.html", changeset: changeset, question: Question.get(question_id))
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
    options =
      question_params
      |> Map.delete("text")
      |> Enum.map(fn {_k,v} -> v end)
    answers =
      options
      |> Map.new(fn opt -> {opt, 0} end)
    %{
      text: question_params["text"],
      options: options,
      answers: answers
    }
  end

  def delete(conn, %{"question_id" => question_id, "session_id" => session_id}) do
    case Question.delete(question_id) do
      {:ok, _} ->
        PropollrWeb.Endpoint.broadcast("session:#{session_id}", "remove_question", %{id: question_id})
        conn
        |> put_flash(:info, "Question Deleted")
        |> redirect(to: session_path(conn, :edit, session_id: session_id))
      {:error, message} ->
        conn
        |> put_flash(:error, "An Error occurred while trying to delete this question. " <> message)
        |> redirect(to: session_path(conn, :edit, session_id: session_id))
        |> halt()
    end
  end

end
