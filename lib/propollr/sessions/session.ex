defmodule Propollr.Sessions.Session do
  use Ecto.Schema
  alias Propollr.Repo
  alias Propollr.Questions.Question
  import Ecto.Changeset
  import Ecto.Query

  schema "sessions" do
    field :closed, :boolean, default: false
    field :session_id, :string
    has_many :questions, Propollr.Questions.Question
    belongs_to :user, Propollr.Users.User
    timestamps()
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:closed, :session_id])
    |> validate_required([:closed, :session_id])
  end

  def new() do
    session_id = randomize_session_id()
    case Repo.get_by(Session, session_id: session_id) do
      nil -> 
        Repo.insert!(%Session{closed: false, session_id: session_id})
        _ -> new() # Keep trying till we get a unique session_id
    end
  end

  def with_questions(session_id) do
    Repo.get_by(Session, session_id: session_id) |> Repo.preload(:questions)
  end

  def randomize_session_id() do
    Ecto.UUID.generate |> binary_part(16,16)
  end
end
