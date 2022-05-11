defmodule Relix.PostegresRecipeStoreIntegrationTest do
  use Relix.RecipeRepoCase

  alias Relix.RecipeStore.PostgresStore
  alias Relix.Recipe

  @tag :database
  test "create recipe" do
    {:ok, persisted} =
      PostgresStore.insert(Recipe.new(1, "Recipe1", "RECIPE", %{"1" => "2"}) |> elem(1))

    assert persisted.id == 1
    assert persisted.name == "Recipe1"
    assert persisted.type == "RECIPE"
    assert persisted.version == 1
    assert persisted.state == :draft
    assert persisted.items == %{"1" => "2"}
  end

  @tag :database
  test "get next identity" do
    assert PostgresStore.get_next_identity() < PostgresStore.get_next_identity()
  end

  @tag :database
  test "get recipes" do
    assert PostgresStore.get_recipes() == []

    {:ok, persisted} = PostgresStore.insert(Recipe.new(1, "Recipe1", "RECIPE", %{}) |> elem(1))

    assert PostgresStore.get_recipes() |> length == 1
    assert PostgresStore.get_recipes() == [persisted]
  end

  @tag :database
  test "get recipe by id" do
    {:ok, persisted} = PostgresStore.insert(Recipe.new(1, "Recipe1", "RECIPE", %{}) |> elem(1))
    assert PostgresStore.get_recipe_by_id(persisted.id) == persisted

    assert PostgresStore.get_recipe_by_id(42) == :not_found
  end

  @tag :database
  test "delete recipe by id" do
    assert PostgresStore.get_recipes() == []
    assert PostgresStore.delete_by_id(1) == {:error, :not_found}

    {:ok, _persisted} = PostgresStore.insert(Recipe.new(1, "Recipe1", "RECIPE", %{}) |> elem(1))

    assert PostgresStore.get_recipes() |> length == 1
    assert PostgresStore.delete_by_id(1) == :ok
    assert PostgresStore.get_recipes() |> length == 0
  end

  test "update recipe" do
    {:ok, persisted} = PostgresStore.insert(Recipe.new(1, "Recipe1", "RECIPE", %{}) |> elem(1))

    {:ok, updated} =
      PostgresStore.update(%PostgresStore.Recipe{
        id: persisted.id,
        name: "ciccio",
        type: "RECIPE",
        state: :draft,
        version: 1,
        items: %{"mah" => "si"}
      })

    assert updated.name == "ciccio"
    assert updated.items == %{"mah" => "si"}
    assert updated.id == persisted.id
  end
end
