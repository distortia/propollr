defmodule Propollr.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Propollr.Repo
  alias Propollr.Sessions.Session

  schema "questions" do
    field :answers, :map
    field :options, {:array, :string}
    field :text, :string

    belongs_to :session, Propollr.Sessions.Session
    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:text, :answers, :options])
    |> validate_required([:text, :options])
  end

  def answer(session_id, answer_params) do
    session = Session.get(session_id)
    question_list = session.questions
    Enum.each(answer_params, fn {question_text, answer} ->
      if answer == "" do
        #skip it
      else
        question =
          question_list
          |> Enum.filter(fn question -> question.text == question_text end)
          |> List.first()

        question
        |> Ecto.Changeset.change(%{answers: Map.update(question.answers, answer, 1, &(&1 + 1))})
        |> Repo.update!()
      end
    end)
  end
end
