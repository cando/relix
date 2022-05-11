defmodule RecipeTest do
  use ExUnit.Case, async: true
  doctest Relix

  alias Relix.Recipe

  @draft :draft
  @approved :approved

  test "create recipe" do
    assert Recipe.new(1, "Recipe1", "RECIPE", %{}) |> elem(1) == %Recipe{
             id: 1,
             name: "Recipe1",
             type: "RECIPE",
             state: :draft,
             version: 1,
             items: %{}
           }

    assert Recipe.new(1, "Recipe1", "RECIPE", %{"1" => "add eggs", "2" => "mix"}) |> elem(1) ==
             %Recipe{
               id: 1,
               name: "Recipe1",
               type: "RECIPE",
               state: :draft,
               version: 1,
               items: %{"1" => "add eggs", "2" => "mix"}
             }
  end

  test "create recipe with invalid name" do
    assert Recipe.new(1, "", "RECIPE", %{}) |> elem(1) == :validation_error
    assert Recipe.new(1, "", nil, %{}) |> elem(1) == :validation_error
  end

  test "create recipe with invalid type" do
    assert Recipe.new(1, "Recipe 1", "", %{}) |> elem(1) == :validation_error
    assert Recipe.new(1, "Recipe 1", nil, %{}) |> elem(1) == :validation_error
  end

  test "approve recipe" do
    recipe1 = Recipe.new(1, "Recipe1", "RECIPE", %{"pippo" => "pluto"}) |> elem(1)
    assert recipe1.state == @draft
    assert recipe1.version == 1

    recipe1 = Recipe.approve(recipe1)

    assert recipe1.state == @approved
    assert recipe1.version == 1
  end

  test "add item" do
    recipe1 = Recipe.new(1, "Recipe1", "RECIPE", %{}) |> elem(1)
    recipe1 = Recipe.add_or_update_item(recipe1, "Mix eggs", "Long description of mixing eggs")
    assert recipe1.items == %{"Mix eggs" => "Long description of mixing eggs"}
    assert recipe1.state == @draft
    assert recipe1.version == 1

    recipe1 = Recipe.approve(recipe1)
    recipe1 = Recipe.add_or_update_item(recipe1, "Mix eggs", "short")
    assert recipe1.state == @draft
    assert recipe1.version == 2
  end

  test "update item" do
    recipe1 = Recipe.new(1, "Recipe1", "RECIPE", %{"pippo" => "pluto"}) |> elem(1)
    recipe1 = Recipe.add_or_update_item(recipe1, "pippo", "puppa")
    assert recipe1.items == %{"pippo" => "puppa"}
    assert recipe1.state == @draft
    assert recipe1.version == 1

    recipe1 = Recipe.approve(recipe1)
    recipe1 = Recipe.add_or_update_item(recipe1, "pippo", "pappa")
    assert recipe1.state == @draft
    assert recipe1.version == 2
  end

  test "delete item" do
    recipe1 = Recipe.new(1, "Recipe1", "RECIPE", %{"pippo" => "pluto"}) |> elem(1)
    recipe1 = Recipe.delete_item(recipe1, "pippo")
    assert recipe1.items == %{}
    assert recipe1.state == @draft
    assert recipe1.version == 1

    recipe2 = Recipe.delete_item(recipe1, "pippo")
    assert recipe1 == recipe2

    recipe1 = Recipe.new(1, "Recipe1", "RECIPE", %{"A" => "B"}) |> elem(1)
    recipe1 = Recipe.approve(recipe1)

    recipe1 = Recipe.delete_item(recipe1, "NO ESISTS")
    assert recipe1.items == %{"A" => "B"}
    assert recipe1.state == @approved
    assert recipe1.version == 1

    recipe1 = Recipe.delete_item(recipe1, "A")
    assert recipe1.items == %{}
    assert recipe1.state == @draft
    assert recipe1.version == 2
  end
end
