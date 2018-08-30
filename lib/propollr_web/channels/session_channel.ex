defmodule PropollrWeb.SessionChannel do
  use Phoenix.Channel
  alias Propollr.Questions.Question
  alias Propollr.Sessions.Session

  def join("session:" <> session_id, _params, socket) do
    send(self(), {:after_join, session_id})
    {:ok, socket}
  end

  def handle_info({:after_join, session_id}, socket) do
    session =
      session_id
      |> Session.get_by()

      questions =
      session.questions
      |> Enum.map(fn q -> %{text: q.text, options: q.options, answers: q.answers, id: q.id} end)

      socket = assign(socket, :session_id, session_id)

      # Send the initial barrage of questions and answers
      push(socket, "questions", %{questions: questions})
      {:noreply, socket}
  end

  def handle_in("answer", %{"question_id" => question_id, "answer" => answer}, socket) do
    case Question.answer(question_id, answer) do
      {:ok, question} ->
        payload = %{question: question.text, question_id: question.id, answers: question.answers}
        broadcast(socket, "updated_answer", payload)
        {:noreply, socket}
      {:error, changeset} ->
        {:reply, {:error, changeset}}
    end
  end

  def handle_in("question:answer", attrs, socket) do
    question = Question.answer(attrs.session_id, attrs.session_params)
    {:reply, {:ok, question}, socket}
  end
end
