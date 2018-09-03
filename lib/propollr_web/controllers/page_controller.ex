defmodule PropollrWeb.PageController do
  use PropollrWeb, :controller
  alias PropollrWeb.Feedback.FeedbackEmail
  alias PropollrWeb.Feedback.Mailer
  def index(conn, _params) do
    render(conn, "index.html")
  end

  def feedback(conn, %{"feedback" => feedback}) do
    # send email to us
    FeedbackEmail.generate(feedback) |> Mailer.deliver()
    origin = 
    conn
    |> Plug.Conn.get_req_header("referer")
    |> List.first()
    |> String.split("/")
    |> List.last
    
    conn
    |> put_flash(:info, "Feedback sent! We really appreciate it!")
    |> redirect(to: "/" <> origin)
  end
end
