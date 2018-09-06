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

  def newsletter(conn, %{"email" => email}) do
    # TODO: sign them up for our newsletter
    conn
    |> put_flash(:info, "Thanks for signing up for our newsletter!")
    |> render("index.html")
  end

  def contact(conn, %{"message" => message}) do
    # TODO: Send us a contact massge, similar to feedback
    conn
    |> put_flash(:info, "Thanks for your message! We will respond as soon as possible.")
    |> render("index.html")
  end
end
