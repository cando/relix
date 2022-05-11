defmodule Relix.RecipeStore.PostgresStore.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :relix,
    adapter: Ecto.Adapters.Postgres
end
