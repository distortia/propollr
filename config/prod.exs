use Mix.Config

# For production, we often load configuration from external
# sources, such as your system environment. For this reason,
# you won't find the :http configuration below, but set inside
# PropollrWeb.Endpoint.init/2 when load_from_system_env is
# true. Any dynamic configuration should be done there.
#
# Don't forget to configure the url host to something meaningful,
# Phoenix uses this information when generating URLs.
#
# Finally, we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the mix phx.digest task
# which you typically run after static files are built.
config :propollr, PropollrWeb.Endpoint,
  load_from_system_env: true,
  url: [host: "propollr.com", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
    config :propollr, PropollrWeb.Endpoint,
      url: [host: "propollr.com", port: 443],
      https: [:inet6,
              port: 443,
              keyfile: "/etc/letsencrypt/live/propollr.com/privkey.pem",
              cacertfile: "/etc/letsencrypt/live/propollr.com/chain.pem",
              certfile: "/etc/letsencrypt/live/propollr.com/cert.pem"]

              config :propollr, PropollrWeb.Endpoint,
#
# Where those two env variables return an absolute path to
# the key and cert in disk or a relative path inside priv,
# for example "priv/ssl/server.key".
#
# We also recommend setting `force_ssl`, ensuring no data is
# ever sent via http, always redirecting to https:
#
    config :propollr, PropollrWeb.Endpoint,
      force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :propollr, PropollrWeb.Endpoint, server: true
#

# Finally import the config/prod.secret.exs
# which should be versioned separately.

config :propollr, PropollrWeb.Endpoint,
check_origin: ["//propollr.com", "//35.202.203.25"]
import_config "prod.secret.exs"
