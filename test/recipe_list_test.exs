defmodule Relix.RecipeListTest do
  import Mox
  use ExUnit.Case, async: true
  doctest Relix
  setup :verify_on_exit!

  alias Relix.Recipe

  setup_all _ do
    Mox.defmock(RecipeStoreBehaviourMock, for: Relix.RecipeStore.Behaviour)
    Application.put_env(:relix, :recipe_repo, RecipeStoreBehaviourMock)
  end

  describe "manage recipes" do
    test "new recipe" do
      RecipeStoreBehaviourMock
      |> expect(:get_next_identity, 2, fn -> 1 end)
      |> expect(:save, 1, fn r -> {:ok, r} end)

      assert Relix.RecipeList.new_recipe("Recipe1", "RECIPE", %{1 => 2}) |> elem(1) ==
               %Recipe{
                 id: 1,
                 name: "Recipe1",
                 type: "RECIPE",
                 state: :draft,
                 version: 1,
                 items: %{1 => 2}
               }

      assert Relix.RecipeList.new_recipe(nil, "RECIPE", %{1 => 2}) == {:error, :validation_error}
    end

    test "delete recipe" do
      Mox.stub_with(RecipeStoreBehaviourMock, Relix.StubRecipeStore)

      assert Relix.RecipeList.delete_recipe(1) == :ok
      assert Relix.RecipeList.delete_recipe(42) == :not_found
    end

    test "get recipes" do
      Mox.stub_with(RecipeStoreBehaviourMock, Relix.StubRecipeStore)

      assert Relix.RecipeList.get_recipes() == [
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

    test "get recipe by id" do
      Mox.stub_with(RecipeStoreBehaviourMock, Relix.StubRecipeStore)

      recipe = Relix.RecipeList.new_recipe("Recipe1", "RECIPE", %{1 => 2}) |> elem(1)
      stub(RecipeStoreBehaviourMock, :get_recipes, fn -> [recipe] end)

      assert Relix.RecipeList.get_recipe_by_id(recipe.id) == recipe
      assert Relix.RecipeList.get_recipe_by_id(42) == :not_found
    end

    test "update recipe" do
      Mox.stub_with(RecipeStoreBehaviourMock, Relix.StubRecipeStore)

      recipe = Relix.RecipeList.new_recipe("Recipe1", "RECIPE", %{1 => 2}) |> elem(1)

      stub(RecipeStoreBehaviourMock, :get_recipes, fn -> [recipe] end)

      assert Relix.RecipeList.update_recipe(%Recipe{recipe | name: "RecipeNuova"}) ==
               {:ok, %Recipe{recipe | name: "RecipeNuova"}}

      assert Relix.RecipeList.update_recipe(%Recipe{recipe | id: :fake, name: "RecipeNuova"}) ==
               :not_found
    end
  end
end
