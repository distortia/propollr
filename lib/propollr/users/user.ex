defmodule Propollr.Users.User do
  alias Propollr.Repo
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query


  schema "users" do
    field :random_user_id, :string
    field :username, :string
    field :password, :string
    has_many :sessions, Propollr.Sessions.Session
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:random_user_id])
    |> validate_required([:random_user_id])
  end

  def new(user) do
    Repo.insert!(user)
  end

  def get(user_id) do
    Repo.get(__MODULE__, user_id) |> Repo.preload(:sessions)
  end

  def get_by_username(username) do
    Repo.get_by(__MODULE__, username: username) |> Repo.preload(:sessions)
  end
end
