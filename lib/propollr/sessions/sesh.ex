defmodule Propollr.Seshes.Sesh do
  use Ecto.Schema
  alias Propollr.Repo
  alias Propollr.Veil.User
  import Ecto.Changeset
  import Ecto.Query

  schema "seshes" do
    field(:closed, :boolean, default: false)
    field(:sesh_id, :string)
    field(:title, :string)
    has_many(:questions, Propollr.Questions.Question)
    belongs_to(:user, Propollr.Veil.User)
    timestamps()
  end

  @doc false
  def changeset(sesh, attrs) do
    sesh
    |> cast(attrs, [:closed, :sesh_id, :title])
    |> validate_required([:closed, :sesh_id, :title])
    |> add_sesh_id()
  end

  def add_sesh_id(sesh) do
    if sesh.data.sesh_id, do: sesh, else: sesh |> put_change(:sesh_id, randomize_sesh_id())
  end

  def create(user, sesh_params) do
    sesh_id = randomize_sesh_id()

    user
    |> Ecto.build_assoc(:seshes, %{closed: false, sesh_id: sesh_id, title: sesh_params["title"]})
    |> __MODULE__.changeset(sesh_params)
    |> Repo.insert()
  end

  def soft_sesh(sesh_params, user) do
    user
    |> Ecto.build_assoc(:seshes, %__MODULE__{
      closed: false,
      sesh_id: randomize_sesh_id(),
      title: sesh_params["title"]
    })
    |> Repo.insert!()
    |> Repo.preload(:user)
  end

  def get(id) do
    __MODULE__
    |> Repo.get(id)
    |> Repo.preload(:questions)
    |> Repo.preload(:user)
  end

  def get_by(sesh_id) do
    __MODULE__
    |> Repo.get_by(sesh_id: sesh_id)
    |> Repo.preload(:questions)
    |> Repo.preload(:user)
  end

  def get_opened(user_id) do
    Repo.all(from(s in __MODULE__, where: s.closed == ^false and s.user_id == ^user_id))
    |> Repo.preload(:questions)
    |> Repo.preload(:user)
  end

  def get_closed(user_id) do
    Repo.all(from(s in __MODULE__, where: s.closed == ^true and s.user_id == ^user_id))
    |> Repo.preload(:questions)
    |> Repo.preload(:user)
  end

  def reopen(sesh_id) do
    __MODULE__
    |> Repo.get_by(sesh_id: sesh_id)
    |> __MODULE__.changeset(%{closed: false})
    |> Repo.update()
  end

  def close(sesh_id) do
    sesh_id
    |> __MODULE__.get_by()
    |> __MODULE__.changeset(%{closed: true})
    |> Repo.update()
  end

  def update(sesh_id, sesh_params) do
    sesh_id
    |> __MODULE__.get_by()
    |> __MODULE__.changeset(sesh_params)
    |> Repo.update()
  end

  def randomize_sesh_id() do
    Ecto.UUID.generate() |> binary_part(16, 16)
  end
end
