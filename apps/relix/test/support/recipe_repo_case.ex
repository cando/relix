defmodule Relix.RecipeRepoCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Relix.RecipeStore.PostgresStore.Repo

      import Ecto
      import Ecto.Query
      import Relix.RecipeRepoCase
    end
  end

  setup tags do
    start_supervised(Relix.RecipeStore.PostgresStore.Repo)
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Relix.RecipeStore.PostgresStore.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Relix.RecipeStore.PostgresStore.Repo, {:shared, self()})
    end

    :ok
  end
end
