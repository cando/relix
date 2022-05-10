import Config

config :relix, :recipe_repo, Relix.RecipeStore.PostgresStore
config :logger, level: :debug

config :relix, Relix.RecipeStore.PostgresStore.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "db_relix"
