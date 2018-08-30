defmodule Propollr.Sessions.Session do
  use Ecto.Schema
  alias Propollr.Repo
  alias Propollr.Users.User
  import Ecto.Changeset
  import Ecto.Query

  schema "sessions" do
    field :closed, :boolean, default: false
    field :session_id, :string
    field :title, :string
    has_many :questions, Propollr.Questions.Question
    belongs_to :user, Propollr.Users.User
    timestamps()
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:closed, :session_id, :title])
    |> validate_required([:closed, :session_id, :title])
    |> add_session_id()
  end

  def add_session_id(session) do
    if session.data.session_id, do: session, else: session |> put_change(:session_id, randomize_session_id())
  end

  def create(user, session_params) do
    session_id = randomize_session_id()
    user
    |> Ecto.build_assoc(:sessions, %{closed: false, session_id: session_id, title: session_params["title"]})
    |> __MODULE__.changeset(session_params)
    |> Repo.insert()
  end

  def soft_session(session_params, user) do
    user
    |> Ecto.build_assoc(:sessions, %__MODULE__{closed: false, session_id: randomize_session_id(), title: session_params["title"]})
    |> Repo.insert!()
    |> Repo.preload(:user)
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

  def get_opened(user_id) do
    Repo.all(from s in __MODULE__, where: s.closed == ^false and s.user_id == ^user_id)
    |> Repo.preload(:questions)
    |> Repo.preload(:user)
  end

  def get_closed(user_id) do
    Repo.all(from s in __MODULE__, where: s.closed == ^true and s.user_id == ^user_id)
    |> Repo.preload(:questions)
    |> Repo.preload(:user)
  end

  def reopen(session_id) do
    __MODULE__
    |> Repo.get_by(session_id: session_id)
    |> __MODULE__.changeset(%{closed: false})
    |> Repo.update()
  end

  def close(session_id) do
    session_id
    |> __MODULE__.get_by()
    |> __MODULE__.changeset(%{closed: true})
    |> Repo.update()
  end

  def update(session_id, session_params) do
    session_id
    |> __MODULE__.get_by()
    |> __MODULE__.changeset(session_params)
    |> Repo.update()
  end

  def randomize_session_id() do
    Ecto.UUID.generate |> binary_part(16,16)
  end
end
