defmodule Relix.EtsStoreIntegrationTest do
  @moduledoc false
  use ExUnit.Case

  alias Relix.RecipeStore.EtsStore
  alias Relix.Recipe

  setup _ do
    start_supervised({EtsStore, name: __MODULE__})
    :ok
  end

  test "create recipe" do
    {:ok, persisted} =
      EtsStore.insert(Recipe.new(1, "Recipe1", "RECIPE", %{"1" => "2"}) |> elem(1))

    assert persisted.id == 1
    assert persisted.name == "Recipe1"
    assert persisted.type == "RECIPE"
    assert persisted.version == 1
    assert persisted.state == :draft
    assert persisted.items == %{"1" => "2"}
  end

  test "get next identity" do
    assert EtsStore.get_next_identity() < EtsStore.get_next_identity()
  end

  test "get recipes" do
    assert EtsStore.get_recipes() == []

    {:ok, persisted} = EtsStore.insert(Recipe.new(1, "Recipe1", "RECIPE", %{}) |> elem(1))

    assert EtsStore.get_recipes() |> length == 1
    assert EtsStore.get_recipes() == [persisted]
  end

  test "get recipe by id" do
    {:ok, persisted} = EtsStore.insert(Recipe.new(1, "Recipe1", "RECIPE", %{}) |> elem(1))
    assert EtsStore.get_recipe_by_id(persisted.id) |> elem(1) == persisted

    assert EtsStore.get_recipe_by_id(42) |> elem(1) == :not_found
  end

  test "delete recipe by id" do
    assert EtsStore.get_recipes() == []
    assert EtsStore.delete_by_id(1) == {:error, :not_found}

    {:ok, _persisted} = EtsStore.insert(Recipe.new(1, "Recipe1", "RECIPE", %{}) |> elem(1))

    assert EtsStore.get_recipes() |> length == 1
    assert EtsStore.delete_by_id(1) == :ok
    assert EtsStore.get_recipes() |> length == 0
  end

  test "update recipe" do
    {:ok, persisted} = EtsStore.insert(Recipe.new(1, "Recipe1", "RECIPE", %{}) |> elem(1))

    {:ok, updated} =
      EtsStore.update(%Recipe{
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
