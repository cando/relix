import Config

config :relix, Relix.RecipeStore.PostgresStore.Repo,
  username: System.get_env("PGUSER", "postgres"),
  password: System.get_env("PGPASSWORD", "postgres"),
  hostname: System.get_env("PGHOST", "localhost"),
  database: "db_relix_test",
  pool: Ecto.Adapters.SQL.Sandbox

# Phoenix Stuffs
#
# We don't run a server during test. If one is required,
# you can enable the server option below.
config :relix_web, RelixWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "2tqSfcqdFqscAJcpF7J8ikZD3P3T77gQgW5GkiGGDPPEyFNhZzWAktiLpfRbzkdI",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
