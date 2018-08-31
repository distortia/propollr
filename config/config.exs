# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :propollr,
  ecto_repos: [Propollr.Repo]

# Configures the endpoint
config :propollr, PropollrWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "WbvZY8zmWYKRWuKNkwbB1a6P659H0K0/rAdyhazDrQBpcvh/dIjgHtVzIh9PtmtA",
  render_errors: [view: PropollrWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Propollr.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"


# -- Veil Configuration    Don't remove this line
config :veil,
  site_name: "ProPollr.com",
  email_from_name: "The ProPollr Team",
  email_from_address: "us@propollr.com",
  sign_in_link_expiry: 3_600,
  session_expiry: 86_400 * 30,
  refresh_expiry_interval: 86_400

config :veil,Veil.Scheduler,
  jobs: [
    # Runs every midnight to delete all expired requests and sessions
    {"@daily", {Propollr.Veil.Clean, :expired, []}}
  ]

config :veil, PropollrWeb.Veil.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "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"

# -- End Veil Configuration
