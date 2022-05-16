import Config

config :relix, :recipe_store, Relix.RecipeStore.EtsStore
config :logger, level: :warn

config :relix, Relix.RecipeStore.PostgresStore.Repo,
  username: System.get_env("PGUSER", "postgres"),
  password: System.get_env("PGPASSWORD", "postgres"),
  hostname: System.get_env("PGHOST", "localhost"),
  database: "db_relix_bench",
  pool_size: 100
