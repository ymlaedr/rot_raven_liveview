# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :rot_raven,
  ecto_repos: [RotRaven.Repo]

# Configures the endpoint
config :rot_raven, RotRavenWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "l6QZHSFm08B8TnzHBLTo4NheZ2Dag+f8p4PT/lJoaz5kfENZPuZHVN95VycuT0/F",
  render_errors: [view: RotRavenWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RotRaven.PubSub, adapter: Phoenix.PubSub.PG2],
  signing_salt: "PqLtEpvArH3txuRs2sUpVhbSs0VoCOO+"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :rot_raven, RotRavenWeb.Endpoint,
  live_view: [
    signing_salt: "9O3HAwDr4sLLnHcIpn8CERn8O/e/JZFW"
  ]
