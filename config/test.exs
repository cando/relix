import Config

config :relix, Relix.RecipeStore.PostgresStore.Repo,
  username: "sa",
  password: "imapass",
  database: "recipe2sql",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
