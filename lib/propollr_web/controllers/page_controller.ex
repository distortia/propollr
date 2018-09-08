defmodule PropollrWeb.PageController do
  use PropollrWeb, :controller
  alias PropollrWeb.FeedbackEmail
  alias PropollrWeb.ContactEmail
  alias PropollrWeb.Mailer
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

  def contact(conn, %{"message" => message, "email" => email}) do
    ContactEmail.generate(email, message) |> Mailer.deliver()

    conn
    |> put_flash(:info, "Thanks for your message! We will respond as soon as possible.")
    |> redirect(to: page_path(conn, :index))
  end
end
