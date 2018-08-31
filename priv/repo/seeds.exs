# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Propollr.Repo.insert!(%Propollr.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Propollr.Repo
alias Propollr.Veil.User
alias Propollr.Sesshes.Sesh
alias Propollr.Questions.Question
import Ecto

user = Repo.insert!(%User{email: "nickstalter@gmail.com", verified: true})

sesh =
user
|> Ecto.build_assoc(:seshes, %{closed: false, sesh_id: "123", title: "Simple Math"})
|> Repo.insert!()

sesh
|> Ecto.build_assoc(
  :questions,
  %{text: "2 + 2?",
    options: ["1" , "2", "3", "4"],
    answers: %{"1" => 0, "2" => 0, "3" => 0, "4" => 0}}
  )
|> Repo.insert!()
