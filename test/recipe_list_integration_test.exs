defmodule Relix.RecipeListIntegrationTest do
  use Relix.RecipeRepoCase

  setup_all _ do
    Application.put_env(:relix, :recipe_repo, Relix.RecipeStore.PostgresStore)
  end

  describe "manage recipes" do
    @tag :database
    test "new recipe" do
      assert Relix.RecipeList.new_recipe(nil, "RECIPE", %{"1" => "2"}) ==
               {:error, :validation_error}

      recipe = Relix.RecipeList.new_recipe("Recipe1", "RECIPE", %{"1" => "2"}) |> elem(1)

      assert recipe.name == "Recipe1"
      assert recipe.type == "RECIPE"
      assert recipe.state == :draft
      assert recipe.version == 1
      assert recipe.items == %{"1" => "2"}
    end

    test "delete recipe" do
      recipe = Relix.RecipeList.new_recipe("Recipe1", "RECIPE", %{}) |> elem(1)

      assert length(Relix.RecipeList.get_recipes()) == 1
      assert Relix.RecipeList.delete_recipe(recipe.id) == :ok
      assert length(Relix.RecipeList.get_recipes()) == 0
    end

    test "get recipes" do
      assert Relix.RecipeList.get_recipes() == []
      recipe = Relix.RecipeList.new_recipe("Recipe1", "RECIPE", %{}) |> elem(1)

      assert Relix.RecipeList.get_recipes() |> Enum.at(0) == recipe
    end

    test "get recipe by id" do
      recipe = Relix.RecipeList.new_recipe("Recipe1", "RECIPE", %{"1" => "2"}) |> elem(1)
      assert Relix.RecipeList.get_recipe_by_id(recipe.id) == recipe
      assert Relix.RecipeList.get_recipe_by_id(42) == :not_found
    end

    test "rename recipe" do
      recipe = Relix.RecipeList.new_recipe("Recipe1", "RECIPE", %{"1" => "2"}) |> elem(1)

      assert Relix.RecipeList.rename_recipe(recipe.id, "RecipeNuova") ==
               {:ok, %Relix.Recipe{recipe | name: "RecipeNuova"}}

      assert Relix.RecipeList.rename_recipe(42, "RecipeNuova") ==
               {:error, :not_found}

      # TODO add or update item test sia nel dominio, che nell'integration
    end
  end
end
