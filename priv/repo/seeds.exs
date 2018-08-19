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

user = Repo.insert!(%User{username: "nick", email: "me@nickstalter.com", password: "123"})

session = 
user
|> Ecto.build_assoc(:sessions, %{closed: false, session_id: "123"})
|> Repo.insert!()

session
|> Ecto.build_assoc(
  :questions,%{
  "text" => "yes?",
  "options" => %{"option1" => "yes", "option2" => "no", "option3" => "idk", "option4" => "kinda"},
  "answers" => %{}
})
|> Repo.insert!()