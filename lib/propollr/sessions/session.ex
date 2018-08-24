defmodule Propollr.Sessions.Session do
  use Ecto.Schema
  alias Propollr.Repo
  alias Propollr.Questions.Question
  alias Propollr.Users.User
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
    |> put_change(:session_id, randomize_session_id())
  end

  def new(random_user_id) do
    session_id = randomize_session_id()
    case Repo.get_by(__MODULE__, session_id: session_id) do
      nil ->
        %User{random_user_id: random_user_id}
        |> User.new()
        |> Ecto.build_assoc(:sessions, %__MODULE__{closed: false, session_id: session_id})
        |> Repo.insert!()

        _ -> new(random_user_id) # Keep trying till we get a unique session_id
    end
  end

  def with_questions(session_id) do
    case Repo.get_by(__MODULE__, session_id: session_id, closed: false) do
      nil -> {:error, :inavlid_session}
      session ->
        session
        |> Repo.preload(:questions)
        |> Repo.preload(:user)
    end
  end

  def get(id) do
    __MODULE__
    |> Repo.get(id)
    |> Repo.preload(:questions)
    |> Repo.preload(:user)
  end

  def get_by(session_id) do
    __MODULE__
    |> Repo.get_by(session_id: session_id)
    |> Repo.preload(:questions)
    |> Repo.preload(:user)
  end

  def randomize_session_id() do
    Ecto.UUID.generate |> binary_part(16,16)
  end
end
