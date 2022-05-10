import Config

config :relix, ecto_repos: [Relix.RecipeStore.PostgresStore.Repo]
config :logger, level: :warn

import_config "#{Mix.env()}.exs"
