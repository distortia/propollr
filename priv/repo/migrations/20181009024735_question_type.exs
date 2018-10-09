defmodule Propollr.Repo.Migrations.QuestionType do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      add :type, :string
    end
  end
end
