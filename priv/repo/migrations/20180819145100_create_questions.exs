defmodule Propollr.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :random_user_id, :string
      add :username, :string
      add :password, :string

      timestamps()
    end
    create table(:sessions) do
      add :closed, :boolean, default: false, null: false
      add :session_id, :string
      add :title, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create table(:questions) do
      add :text, :string
      add :answers, :map
      add :options, {:array, :string}
      add :session_id, references(:sessions, on_delete: :nothing)

      timestamps()
    end

    create index(:sessions, [:user_id])
    create index(:questions, [:session_id])
  end
end
