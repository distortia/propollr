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
alias Propollr.Users.User
alias Propollr.Sessions.Session
alias Propollr.Questions.Question
import Ecto

user = Repo.insert!(%User{random_user_id: "123", username: "nick", password: "123"})

session =
user
|> Ecto.build_assoc(:sessions, %{closed: false, session_id: "123"})
|> Repo.insert!()

session
|> Ecto.build_assoc(
  :questions,
  %{text: "2 + 2?",
    options: ["1" , "2", "3", "4"],
    answers: %{"1" => 0, "2" => 0, "3" => 0, "4" => 0}}
  )
|> Repo.insert!()
