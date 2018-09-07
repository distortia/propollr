defmodule PropollrWeb.ContactEmail do
  use Phoenix.Swoosh, view: PropollrWeb.Veil.EmailView

  def generate(email, message) do
    new()
    |> to("alphaity+propollr@alphaity.io")
    |> from(email)
    |> subject("New Contact Message")
    |> text_body(message)
  end
end
