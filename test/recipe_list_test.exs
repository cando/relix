defmodule Relix.RecipeListTest do
  use ExUnit.Case, async: true
  doctest Relix

  alias Relix.Recipe

  test "new recipe" do
    {:ok, pid} = Relix.RecipeList.start_link("test1")

    assert Relix.RecipeList.new(pid, "Recipe1", "RECIPE", %{1 => 2}) ==
              %Recipe{
                id: 1,
                name: "Recipe1",
                type: "RECIPE",
                state: :draft,
                version: 1,
                items: %{1 => 2}
              }

    assert Relix.RecipeList.get_recipes(pid) |> length() == 1
    assert Relix.RecipeList.new(pid, nil, "RECIPE", %{1 => 2}) == :validation_error
    assert Relix.RecipeList.get_recipes(pid) |> length() == 1
  end

  test "delete recipe" do
    {:ok, pid} = Relix.RecipeList.start_link("test1")

    recipe = Relix.RecipeList.new(pid, "Recipe1", "RECIPE", %{1 => 2})

    assert Relix.RecipeList.delete(pid, recipe.id) == :ok
    assert Relix.RecipeList.get_recipes(pid) |> length() == 0
    assert Relix.RecipeList.delete(pid, recipe.id) == :not_found
  end

  test "get recipes" do
    {:ok, pid} = Relix.RecipeList.start_link("test1")

    assert Relix.RecipeList.get_recipes(pid) == []

    Relix.RecipeList.new(pid, "Recipe1", "RECIPE", %{1 => 2})

    assert Relix.RecipeList.get_recipes(pid) == [
             %Recipe{
               id: 1,
               name: "Recipe1",
               type: "RECIPE",
               state: :draft,
               version: 1,
               items: %{1 => 2}
             }
           ]
  end

  test "get by id" do
    {:ok, pid} = Relix.RecipeList.start_link("test1")
    recipe = Relix.RecipeList.new(pid, "Recipe1", "RECIPE", %{1 => 2})

    assert Relix.RecipeList.get(pid, recipe.id) == recipe
    assert Relix.RecipeList.get(pid, 42) == :not_found
  end

  test "update" do
    {:ok, pid} = Relix.RecipeList.start_link("test1")
    recipe = Relix.RecipeList.new(pid, "Recipe1", "RECIPE", %{1 => 2})

    :ok = Relix.RecipeList.update(pid, recipe.id, %Recipe{recipe | name: "RecipeNuova"})

    assert Relix.RecipeList.get(pid, recipe.id).name == "RecipeNuova"
    assert Relix.RecipeList.get(pid, recipe.id).type == "RECIPE"
    assert Relix.RecipeList.get(pid, recipe.id).items == %{1 => 2}
  end
end
