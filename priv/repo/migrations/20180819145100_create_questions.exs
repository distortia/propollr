defmodule Propollr.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:veil_users) do
      add(:email, :string)
      add(:verified, :boolean, default: false)

      timestamps()
    end

    create(unique_index(:veil_users, [:email]))

    create table(:veil_requests) do
      add(:user_id, references(:veil_users, on_delete: :delete_all))
      add(:unique_id, :string)
      add(:phoenix_token, :string)
      add(:ip_address, :string)

      timestamps()
    end

    create(index(:veil_requests, [:unique_id]))

    create table(:veil_sessions) do
      add(:user_id, references(:veil_users, on_delete: :delete_all))
      add(:unique_id, :string)
      add(:phoenix_token, :string)
      add(:ip_address, :string)

      timestamps()
    end

    create(index(:veil_sessions, [:unique_id]))

    create table(:seshes) do
      add :closed, :boolean, default: false, null: false
      add :sesh_id, :string
      add :title, :string
      add :user_id, references(:veil_users, on_delete: :delete_all)

      timestamps()
    end

    create table(:questions) do
      add :text, :string
      add :answers, :map
      add :options, {:array, :string}
      add :sesh_id, references(:seshes, on_delete: :delete_all)

      timestamps()
    end

    create index(:seshes, [:user_id])
    create index(:questions, [:sesh_id])
  end

end
