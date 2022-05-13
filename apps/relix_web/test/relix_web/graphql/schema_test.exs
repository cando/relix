defmodule RelixWeb.SchemaTest do
  @moduledoc false

  use RelixWeb.ConnCase
  alias Relix.Recipe

  @fake_recipe_id 13

  @recipe_query """
  query getRecipe($id: ID!) {
    recipe(id: $id){
      id
      version
      state
      items {
        id
        value
      }
    }
  }
  """

  @all_recipes_query """
  query {
    allRecipes{
      id
      name
      type
      version
      state
      items {
        id
        value
      }
    }
  }
  """

  @add_recipe_mutation """
  mutation createRecipe($name: String!){
    createRecipe(name: $name, type: "RECIPE", items: [{id: "1", value: "2"}, {id: "3", value: "4"}]) {
      id
      name
      type
      items {
        id
        value
      }
    }
  }
  """

  @rename_recipe_mutation """
  mutation renameRecipe($id: ID!, $name: String!){
    renameRecipe(id: $id, name: $name) {
      id
      name
    }
  }
  """

  @delete_recipe_mutation """
  mutation deleteRecipe($id: ID!){
    deleteRecipe(id: $id) {
      id
    }
  }
  """

  @delete_recipe_item_mutation """
  mutation deleteRecipeItem($recipe_id: ID!, $item_id: String!){
    deleteRecipeItem(recipe_id: $recipe_id, item_id: $item_id) {
      id
    }
  }
  """

  @approve_recipe_mutation """
  mutation approveRecipe($id: ID!){
    approveRecipe(id: $id) {
      id,
      state
    }
  }
  """

  @add_or_update_recipe_item """
  mutation addOrUpdateRecipeItem($recipe_id: ID!, $item_id: String!, $item_value: String!){
    addOrUpdateRecipeItem(recipe_id: $recipe_id, item_id: $item_id, item_value: $item_value) {
      id,
      items {
        id
        value
      }
    }
  }
  """

  setup _ do
    start_supervised(Relix.RecipeStore.InMemoryStore)
    Application.put_env(:relix, :recipe_store, Relix.RecipeStore.InMemoryStore)
    {:ok, recipe} = Recipe.new(@fake_recipe_id, "A", "B", %{"1" => "2"})
    Relix.RecipeStore.InMemoryStore.insert(recipe)
    :ok
  end

  describe "query: recipe" do
    test "query: recipe", %{conn: conn} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @recipe_query,
          "variables" => %{id: @fake_recipe_id}
        })

      assert json_response(conn, 200) == %{
               "data" => %{
                 "recipe" => %{
                   "id" => "#{@fake_recipe_id}",
                   "items" => [%{"id" => "1", "value" => "2"}],
                   "state" => "draft",
                   "version" => 1
                 }
               }
             }
    end

    test "query: recipe with invalid id", %{conn: conn} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @recipe_query,
          "variables" => %{id: 42}
        })

      assert json_response(conn, 200)["data"]["errors"] != %{}
    end
  end

  describe "query: all recipe" do
    test "query: all recipes", %{conn: conn} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @all_recipes_query
        })

      assert json_response(conn, 200) == %{
               "data" => %{
                 "allRecipes" => [
                   %{
                     "id" => "#{@fake_recipe_id}",
                     "name" => "A",
                     "type" => "B",
                     "items" => [%{"id" => "1", "value" => "2"}],
                     "state" => "draft",
                     "version" => 1
                   }
                 ]
               }
             }
    end
  end

  describe "mutation: add recipe" do
    test "mutation: add recipe with valid data", %{conn: conn} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @add_recipe_mutation,
          "variables" => %{name: "A"}
        })

      assert json_response(conn, 200) == %{
               "data" => %{
                 "createRecipe" => %{
                   "id" => "1",
                   "name" => "A",
                   "type" => "RECIPE",
                   "items" => [%{"id" => "1", "value" => "2"}, %{"id" => "3", "value" => "4"}]
                 }
               }
             }
    end

    test "mutation: add recipe with invalid data", %{conn: conn} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @add_recipe_mutation,
          "variables" => %{name: ""}
        })

      assert json_response(conn, 200)["data"]["errors"] != %{}
    end
  end

  describe "mutation: delete recipe" do
    test "mutation: delete recipe with valid data", %{conn: conn} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @delete_recipe_mutation,
          "variables" => %{id: @fake_recipe_id}
        })

      assert json_response(conn, 200) == %{
               "data" => %{
                 "deleteRecipe" => %{"id" => "#{@fake_recipe_id}"}
               }
             }
    end

    test "mutation: delete recipe with invalid data", %{conn: conn} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @delete_recipe_mutation,
          "variables" => %{id: 42}
        })

      assert json_response(conn, 200)["data"]["errors"] != %{}
    end
  end

  describe "mutation: rename recipe" do
    test "mutation: rename recipe with valid data", %{conn: conn} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @rename_recipe_mutation,
          "variables" => %{id: @fake_recipe_id, name: "new_name"}
        })

      assert json_response(conn, 200) == %{
               "data" => %{
                 "renameRecipe" => %{"id" => "13", "name" => "new_name"}
               }
             }
    end

    test "mutation: rename recipe with invalid data", %{conn: conn} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @rename_recipe_mutation,
          "variables" => %{id: @fake_recipe_id, name: ""}
        })

      assert json_response(conn, 200)["data"]["errors"] != %{}
    end
  end

  describe "mutation: handling recipe items" do
    test "mutation: delete recipe item with valid data", %{conn: conn} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @delete_recipe_item_mutation,
          "variables" => %{recipe_id: @fake_recipe_id, item_id: "1"}
        })

      assert json_response(conn, 200) == %{
               "data" => %{
                 "deleteRecipeItem" => %{"id" => "1"}
               }
             }
    end

    test "mutation: delete recipe item with invalid data", %{conn: conn} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @delete_recipe_item_mutation,
          "variables" => %{recipe_id: @fake_recipe_id, item_id: "not existent"}
        })

      assert json_response(conn, 200)["data"]["errors"] != %{}
    end
  end

  describe "mutation: approve recipe" do
    test "mutation: approve recipe item with valid data", %{conn: conn} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @approve_recipe_mutation,
          "variables" => %{id: @fake_recipe_id}
        })

      assert json_response(conn, 200) == %{
               "data" => %{
                 "approveRecipe" => %{"id" => "#{@fake_recipe_id}", "state" => "approved"}
               }
             }
    end

    test "mutation: approve recipe item with invalid data", %{conn: conn} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @approve_recipe_mutation,
          "variables" => %{id: 42}
        })

      assert json_response(conn, 200)["data"]["errors"] != %{}
    end
  end

  describe "mutation: add or update recipe item" do
    test "mutation: add recipe item with valid data", %{conn: conn} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @add_or_update_recipe_item,
          "variables" => %{recipe_id: @fake_recipe_id, item_id: "item_nuovo", item_value: "boh"}
        })

      assert json_response(conn, 200) == %{
               "data" => %{
                 "addOrUpdateRecipeItem" => %{
                   "id" => "#{@fake_recipe_id}",
                   "items" => [
                     %{"id" => "1", "value" => "2"},
                     %{"id" => "item_nuovo", "value" => "boh"}
                   ]
                 }
               }
             }
    end

    test "mutation: add or update recipe item with invalid data", %{conn: conn} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @add_or_update_recipe_item,
          "variables" => %{recipe_id: 42, item_id: "item_nuovo", item_value: "boh"}
        })

      assert json_response(conn, 200)["data"]["errors"] != %{}
    end

    test "mutation: update recipe item with valid data", %{conn: conn} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @add_or_update_recipe_item,
          "variables" => %{recipe_id: @fake_recipe_id, item_id: "1", item_value: "new val"}
        })

      assert json_response(conn, 200) == %{
               "data" => %{
                 "addOrUpdateRecipeItem" => %{
                   "id" => "#{@fake_recipe_id}",
                   "items" => [
                     %{"id" => "1", "value" => "new val"}
                   ]
                 }
               }
             }
    end
  end
end
