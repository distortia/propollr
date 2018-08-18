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
