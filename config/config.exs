import Config

# Configure ecto
config :relix, ecto_repos: [Relix.RecipeStore.PostgresStore.Repo]

# Configure Phoenix
config :relix_web, RelixWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: RelixWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: RelixWeb.PubSub,
  live_view: [signing_salt: "IwpKXL09"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :relix_web, :generators, context_app: :relix

import_config "#{Mix.env()}.exs"
