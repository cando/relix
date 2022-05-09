defmodule Relix.RecipeListTest do
  import Mox
  use ExUnit.Case, async: true
  doctest Relix
  setup :verify_on_exit!

  alias Relix.Recipe

  setup_all _ do
    Mox.defmock(RecipeRepoBehaviourMock, for: Relix.Behaviour.RecipeRepo)
    Application.put_env(:relix, :recipe_repo, RecipeRepoBehaviourMock)
  end

  describe "manage recipes" do
    test "new recipe" do
      RecipeRepoBehaviourMock
      |> expect(:get_next_identity, 2, fn -> 1 end)
      |> expect(:save, 1, fn _ -> :ok end)

      assert Relix.RecipeList.new("Recipe1", "RECIPE", %{1 => 2}) |> elem(1) ==
               %Recipe{
                 id: 1,
                 name: "Recipe1",
                 type: "RECIPE",
                 state: :draft,
                 version: 1,
                 items: %{1 => 2}
               }

      assert Relix.RecipeList.new(nil, "RECIPE", %{1 => 2}) == {:error, :validation_error}
    end

    test "delete recipe" do
      Mox.stub_with(RecipeRepoBehaviourMock, Relix.StubRecipeRepo)

      assert Relix.RecipeList.delete(1) == :ok
      assert Relix.RecipeList.delete(42) == :not_found
    end

    test "get recipes" do
      Mox.stub_with(RecipeRepoBehaviourMock, Relix.StubRecipeRepo)

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

    test "get by id" do
      Mox.stub_with(RecipeRepoBehaviourMock, Relix.StubRecipeRepo)

      recipe = Relix.RecipeList.new("Recipe1", "RECIPE", %{1 => 2}) |> elem(1)
      stub(RecipeRepoBehaviourMock, :get_recipes, fn -> [recipe] end)

      assert Relix.RecipeList.get_by_id(recipe.id) == recipe
      assert Relix.RecipeList.get_by_id(42) == :not_found
    end

    test "update" do
      Mox.stub_with(RecipeRepoBehaviourMock, Relix.StubRecipeRepo)

      recipe = Relix.RecipeList.new("Recipe1", "RECIPE", %{1 => 2}) |> elem(1)

      stub(RecipeRepoBehaviourMock, :get_recipes, fn -> [recipe] end)

      assert Relix.RecipeList.update(%Recipe{recipe | name: "RecipeNuova"}) == :ok
      assert Relix.RecipeList.update(%Recipe{recipe | id: :fake, name: "RecipeNuova"}) ==
               :not_found
    end
  end
end
