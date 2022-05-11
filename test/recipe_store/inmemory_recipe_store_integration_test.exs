defmodule Relix.InMemoryecipeStoreIntegrationTest do
  use ExUnit.Case, async: true

  alias Relix.RecipeStore.InMemoryStore
  alias Relix.Recipe

  setup _ do
    start_supervised(InMemoryStore)
    :ok
  end

  test "create recipe" do
    {:ok, persisted} =
      InMemoryStore.insert(Recipe.new(1, "Recipe1", "RECIPE", %{"1" => "2"}) |> elem(1))

    assert persisted.id == 1
    assert persisted.name == "Recipe1"
    assert persisted.type == "RECIPE"
    assert persisted.version == 1
    assert persisted.state == :draft
    assert persisted.items == %{"1" => "2"}
  end

  test "get next identity" do
    assert InMemoryStore.get_next_identity() < InMemoryStore.get_next_identity()
  end

  test "get recipes" do
    assert InMemoryStore.get_recipes() == []

    {:ok, persisted} = InMemoryStore.insert(Recipe.new(1, "Recipe1", "RECIPE", %{}) |> elem(1))

    assert InMemoryStore.get_recipes() |> length == 1
    assert InMemoryStore.get_recipes() == [persisted]
  end

  test "get recipe by id" do
    {:ok, persisted} = InMemoryStore.insert(Recipe.new(1, "Recipe1", "RECIPE", %{}) |> elem(1))
    assert InMemoryStore.get_recipe_by_id(persisted.id) == persisted

    assert InMemoryStore.get_recipe_by_id(42) == :not_found
  end

  test "delete recipe by id" do
    assert InMemoryStore.get_recipes() == []
    assert InMemoryStore.delete_by_id(1) == {:error, :not_found}

    {:ok, _persisted} = InMemoryStore.insert(Recipe.new(1, "Recipe1", "RECIPE", %{}) |> elem(1))

    assert InMemoryStore.get_recipes() |> length == 1
    assert InMemoryStore.delete_by_id(1) == :ok
    assert InMemoryStore.get_recipes() |> length == 0
  end

  test "update recipe" do
    {:ok, persisted} = InMemoryStore.insert(Recipe.new(1, "Recipe1", "RECIPE", %{}) |> elem(1))

    {:ok, updated} =
      InMemoryStore.update(%Recipe{
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
