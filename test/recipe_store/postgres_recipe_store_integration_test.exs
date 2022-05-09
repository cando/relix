defmodule Relix.MySqlRecipeStoreIntegrationTest do
  use Relix.RecipeRepoCase

  alias Relix.RecipeStore.PostgresStore
  alias Relix.Recipe

  @pending
  test "create recipe" do
    assert MySqlStore.save(%Recipe{}) == :ok
  end
end
