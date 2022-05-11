import Config

config :relix, :recipe_store, Relix.RecipeStore.InMemoryStore
config :logger, level: :debug

config :relix, Relix.RecipeStore.PostgresStore.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "db_relix_dev"
