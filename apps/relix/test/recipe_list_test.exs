defmodule Relix.RecipeListTest do
  import Mox
  use ExUnit.Case, async: true
  doctest Relix
  setup :verify_on_exit!

  alias Relix.Recipe

  setup_all _ do
    Mox.defmock(RecipeStoreBehaviourMock, for: Relix.RecipeStore.Behaviour)
    Application.put_env(:relix, :recipe_store, RecipeStoreBehaviourMock)
  end

  describe "manage recipes" do
    test "new recipe" do
      RecipeStoreBehaviourMock
      |> expect(:get_next_identity, 2, fn -> 1 end)
      |> expect(:insert, 1, fn r -> {:ok, r} end)

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

      RecipeStoreBehaviourMock
      |> expect(:delete_by_id, 1, fn _ -> :ok end)

      assert Relix.RecipeList.delete_recipe(1) == :ok
    end

    test "get recipes" do
      Mox.stub_with(RecipeStoreBehaviourMock, Relix.StubRecipeStore)

      RecipeStoreBehaviourMock
      |> expect(:get_recipes, 1, fn ->
        [
          %Recipe{
            id: 1,
            name: "Recipe1",
            type: "RECIPE",
            state: :draft,
            version: 1,
            items: %{1 => 2}
          }
        ]
      end)

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
      RecipeStoreBehaviourMock |> expect(:get_recipe_by_id, 1, fn _ -> {:ok, recipe} end)

      assert Relix.RecipeList.get_recipe_by_id(recipe.id) |> elem(1) == recipe

      RecipeStoreBehaviourMock |> expect(:get_recipe_by_id, 1, fn _ -> {:error, :not_found} end)
      assert Relix.RecipeList.get_recipe_by_id(42) |> elem(1) == :not_found
    end

    test "rename recipe" do
      Mox.stub_with(RecipeStoreBehaviourMock, Relix.StubRecipeStore)

      recipe = Relix.RecipeList.new_recipe("Recipe1", "RECIPE", %{1 => 2}) |> elem(1)

      stub(RecipeStoreBehaviourMock, :get_recipe_by_id, fn _ -> {:ok, recipe} end)

      assert Relix.RecipeList.rename_recipe(recipe.id, "RecipeNuova") ==
               {:ok, %Recipe{recipe | name: "RecipeNuova"}}

      stub(RecipeStoreBehaviourMock, :get_recipe_by_id, fn _ -> {:error, :not_found} end)

      assert Relix.RecipeList.rename_recipe(42, "RecipeNuova") ==
               {:error, :not_found}
    end

    test "approve recipe" do
      Mox.stub_with(RecipeStoreBehaviourMock, Relix.StubRecipeStore)
      recipe = Relix.RecipeList.new_recipe("Recipe1", "RECIPE", %{1 => 2}) |> elem(1)

      assert %Recipe{state: :approved} == Relix.RecipeList.approve_recipe(recipe.id) |> elem(1)
    end
  end

  describe "handling recipe items" do
    test "add item to recipe" do
      Mox.stub_with(RecipeStoreBehaviourMock, Relix.StubRecipeStore)

      recipe = Relix.RecipeList.new_recipe("Recipe1", "RECIPE", %{"1" => "2"}) |> elem(1)

      stub(RecipeStoreBehaviourMock, :get_recipe_by_id, fn _ -> {:ok, recipe} end)

      {:ok, recipe} = Relix.RecipeList.add_or_update_item(recipe.id, "A", "B")

      assert recipe.items["A"] == "B"
      assert recipe.items["1"] == "2"
    end

    test "recipe not found" do
      stub(RecipeStoreBehaviourMock, :get_recipe_by_id, fn _ -> {:error, :not_found} end)
      assert Relix.RecipeList.add_or_update_item(42, "A", "B") == {:error, :not_found}
    end

    test "update item in recipe" do
      Mox.stub_with(RecipeStoreBehaviourMock, Relix.StubRecipeStore)

      recipe = Relix.RecipeList.new_recipe("Recipe1", "RECIPE", %{"1" => "2"}) |> elem(1)

      stub(RecipeStoreBehaviourMock, :get_recipe_by_id, fn _ -> {:ok, recipe} end)

      {:ok, recipe} = Relix.RecipeList.add_or_update_item(recipe.id, "1", "42")

      assert recipe.items["1"] == "42"
    end

    test "delete item in recipe" do
      Mox.stub_with(RecipeStoreBehaviourMock, Relix.StubRecipeStore)

      recipe = Relix.RecipeList.new_recipe("Recipe1", "RECIPE", %{"1" => "2"}) |> elem(1)

      stub(RecipeStoreBehaviourMock, :get_recipe_by_id, fn _ -> {:ok, recipe} end)

      {:ok, recipe} = Relix.RecipeList.delete_item(recipe.id, "NOTEXISTENT")

      assert recipe.items == %{"1" => "2"}

      {:ok, recipe} = Relix.RecipeList.delete_item(recipe.id, "1")

      assert recipe.items == %{}
    end
  end
end
