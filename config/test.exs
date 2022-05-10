import Config

config :relix, Relix.RecipeStore.PostgresStore.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "db_relix_test",
  pool: Ecto.Adapters.SQL.Sandbox
