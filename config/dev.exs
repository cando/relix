import Config

config :relix, Relix.RecipeStore.PostgresStore.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "db_relix"
