defmodule Propollr.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset
  alias Propollr.Repo
  alias Propollr.Seshes.Sesh

  schema "questions" do
    field(:answers, :map)
    field(:type, :string, default: "poll")
    field(:options, {:array, :string})
    field(:text, :string)

    belongs_to(:sesh, Propollr.Seshes.Sesh)
    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:text, :answers, :options, :type])
    |> validate_required([:text, :options, :type])
  end

  def new(question_params) do
    __MODULE__
    |> Ecto.Changeset.change(question_params)
    |> Repo.insert()
  end

  def get(id) do
    __MODULE__
    |> Repo.get(id)
    |> Repo.preload(:sesh)
  end

  def answer(question_id, answer) do
    question =
      question_id
      |> __MODULE__.get()

    question
    |> Ecto.Changeset.change(%{answers: Map.update(question.answers, answer, 1, &(&1 + 1))})
    |> Repo.update()
  end

  def update(question_id, question_params) do
    question =
      question_id
      |> __MODULE__.get()
    original_answers = question.answers

    question
    |> Ecto.Changeset.change(%{question_params | answers: original_answers})
    |> Repo.update()
  end

  def delete(question_id) do
    question_id
    |> __MODULE__.get()
    |> Repo.delete()
  end
end
