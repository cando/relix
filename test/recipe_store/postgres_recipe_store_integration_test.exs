defmodule Relix.PostegresRecipeStoreIntegrationTest do
  use Relix.RecipeRepoCase

  alias Relix.RecipeStore.PostgresStore
  alias Relix.Recipe

  @tag :database
  test "create recipe" do
    {:ok, persisted} = PostgresStore.save(Recipe.new(1, "Recipe1", "RECIPE", %{}) |> elem(1))
    assert persisted.id == 1
    assert persisted.name == "Recipe1"
    assert persisted.type == "RECIPE"
    assert persisted.version == 1
    assert persisted.state == :draft
    assert persisted.items == %{}
  end

  @tag :database
  test "get next identity" do
    assert PostgresStore.get_next_identity() == 1

    {:ok, _persisted} = PostgresStore.save(Recipe.new(1, "Recipe1", "RECIPE", %{}) |> elem(1))

    assert PostgresStore.get_next_identity() == 2
  end

  @tag :database
  test "get recipes" do
    assert PostgresStore.get_recipes() == []

    {:ok, persisted} = PostgresStore.save(Recipe.new(1, "Recipe1", "RECIPE", %{}) |> elem(1))

    assert PostgresStore.get_recipes() |> length == 1
    assert PostgresStore.get_recipes() == [persisted]
  end

  @tag :database
  test "delete recipe by id" do
    assert PostgresStore.get_recipes() == []
    assert PostgresStore.delete_by_id(1) == :ok

    {:ok, _persisted} = PostgresStore.save(Recipe.new(1, "Recipe1", "RECIPE", %{}) |> elem(1))

    assert PostgresStore.get_recipes() |> length == 1
    assert PostgresStore.delete_by_id(1) == :ok
    assert PostgresStore.get_recipes() |> length == 0
  end
end
