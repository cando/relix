defmodule RecipeTest do
  use ExUnit.Case
  doctest Relix

  alias Relix.Recipe

  @approved :approved
  @draft :draft

  test "create recipe" do
    assert Recipe.new("Recipe1", "RECIPE", %{}) == %Recipe{
             name: "Recipe1",
             type: "RECIPE",
             state: :draft,
             version: 1,
             items: %{}
           }

    assert Recipe.new("Recipe1", "RECIPE", %{"1" => "add eggs", "2" => "mix"}) ==
             %Recipe{name: "Recipe1", type: "RECIPE", state: :draft, items: %{"1" => "add eggs", "2" => "mix"}}
  end

  test "create recipe with invalid name" do
    assert Recipe.new("", "RECIPE", %{}) == :error
    assert Recipe.new("", nil, %{}) == :error
  end

  test "create recipe with invalid type" do
    assert Recipe.new("Recipe 1", "", %{}) == :error
    assert Recipe.new("Recipe 1", nil, %{}) == :error
  end

  test "add item" do
    recipe1 = Recipe.new("Recipe1", "RECIPE", %{})
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
    recipe1 = Recipe.new("Recipe1", "RECIPE", %{"pippo" => "pluto"})
    recipe1 = Recipe.add_or_update_item(recipe1, "pippo", "puppa")
    assert recipe1.items == %{"pippo" => "puppa"}
    assert recipe1.state == @draft
    assert recipe1.version == 1

    recipe1 = Recipe.approve(recipe1)
    recipe1 = Recipe.add_or_update_item(recipe1, "pippo", "pappa")
    assert recipe1.state == @draft
    assert recipe1.version == 2
  end
end
