defmodule Propollr.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset
  alias Propollr.Repo
  alias Propollr.Sessions.Session
  require IEx

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

  def new(question_params) do
    __MODULE__
    |> Ecto.Changeset.change(question_params)
    |> Repo.insert()
  end

  def get(id) do
    __MODULE__
    |> Repo.get(id)
    |> Repo.preload(:session)
  end

  def answer(question_id, answer) do
    question =
      question_id
      |> __MODULE__.get()

    question
    |> Ecto.Changeset.change(%{answers: Map.update(question.answers, answer, 1, &(&1 + 1))})
    |> Repo.update()
  end
  # def answer(session_id, answer_params) do
  #   session = Session.get(session_id)
  #   question_list = session.questions
  #   Enum.each(answer_params, fn {question_text, answer} ->
  #     if answer == "" do
  #       #skip it
  #     else
  #       question =
  #         question_list
  #         |> Enum.filter(fn question -> question.text == question_text end)
  #         |> List.first()

  #       question
  #       |> Ecto.Changeset.change(%{answers: Map.update(question.answers, answer, 1, &(&1 + 1))})
  #       |> Repo.update!()
  #     end
  #   end)
  # end

  def update(question_id, question_params) do
    question_id
    |> __MODULE__.get()
    |> Ecto.Changeset.change(question_params)
    |> Repo.update()
  end

  def delete(question_id) do
    question_id
    |> __MODULE__.get()
    |> Repo.delete()
  end
end
