import Config

config :relix, ecto_repos: [Relix.RecipeStore.PostgresStore.Repo]

import_config "#{Mix.env()}.exs"
