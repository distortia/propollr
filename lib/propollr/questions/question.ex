defmodule Propollr.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset


  schema "questions" do
    field :answers, :map
    field :options, :map
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

end
