# This script is intended to alter the questions in the
# datbase to update their types to be poll by default
# This change comes after adding question types
# To run this file on dev:
# $ mix run migrate_question_types.exs
# For Prod:
# $ MIX_ENV=prod mix run migrate_question_types.exs
# If you dont see the changes, restart the server
alias Propollr.Repo
alias Propollr.Questions.Question
Question
|> Repo.all()
|> Enum.each(fn q ->
  IO.inspect q, label: "initial q"
  q
  |> Ecto.Changeset.change(type: "poll")
  |> IO.inspect(label: "after change q")
  |> Repo.update!()
end)
