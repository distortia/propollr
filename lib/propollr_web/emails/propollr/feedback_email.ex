defmodule PropollrWeb.FeedbackEmail do
  use Phoenix.Swoosh, view: PropollrWeb.Veil.EmailView

  def generate(feedback) do
    new()
    |> to("alphaity+propollr@alphaity.io")
    |> from("feedback@propollr.com")
    |> subject("New Feedback!")
    |> text_body(feedback)
  end
end
