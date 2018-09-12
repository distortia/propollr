defmodule PropollrWeb.SeshChannel do
  use Phoenix.Channel
  alias PropollrWeb.Presence
  alias Propollr.Questions.Question
  alias Propollr.Seshes.Sesh
  @secret_key Application.get_env(:propollr, PropollrWeb.Endpoint)[:secret_key_base]
  @token_max_age 86400 * 30

  def join("sesh:" <> sesh_id, _params, socket) do
    send(self(), {:after_join, sesh_id, socket.assigns.question_token})
    {:ok, socket}
  end

  def handle_info({:after_join, sesh_id, question_token}, socket) do
    sesh =
      sesh_id
      |> Sesh.get_by()

    questions =
      sesh.questions
      |> Enum.map(fn q -> %{text: q.text, options: q.options, answers: q.answers, id: q.id} end)

    answered_questions =
    if String.length(question_token) > 0 do
      {:ok, answered_questions} = Phoenix.Token.verify(socket, @secret_key, question_token, max_age: @token_max_age)
      answered_questions
    else
      %{}
    end

    socket = assign(socket, :sesh_id, sesh_id)

    # Send the initial barrage of questions and answers
    push(socket, "questions", %{questions: questions, answered_questions: answered_questions})

    push(socket, "presence_state", Presence.list(socket))
    {:ok, _} = Presence.track(socket, sesh_id, %{
      online_at: inspect(System.system_time(:seconds))
    })
    {:noreply, socket}
  end

  def handle_in("answer", %{"question_id" => question_id, "answer" => answer, "question_token" => question_token}, socket) do
    case Question.answer(question_id, answer) do
      {:ok, question} ->
        payload = %{question: question.text, question_id: question.id, answers: question.answers}
        broadcast(socket, "updated_answer", payload)
        question_list =
        if String.length(question_token) > 0 do
          {:ok, q_list} = Phoenix.Token.verify(socket, @secret_key, question_token, max_age: @token_max_age)
          q_list
        else
          %{}
        end
        answered_questions = map_answered_questions(question_list, question, answer)
        updated_question_token = Phoenix.Token.sign(socket, @secret_key, answered_questions, max_age: @token_max_age)
        {:reply, {:ok, %{question_token: updated_question_token}}, socket}

      {:error, changeset} ->
        {:reply, {:error, changeset}}
    end
  end

  defp map_answered_questions(question_list, question, answer) do
    sesh_id = question.sesh.sesh_id
    if Map.has_key?(question_list, sesh_id) do
      %{question_list | sesh_id => Map.put(question_list[sesh_id], question.id, answer)}
    else
      Map.put(question_list, question.sesh.sesh_id, %{question.id => answer})
    end
  end
end
