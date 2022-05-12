defmodule RelixWeb.RecipeItemControllerTest do
  use RelixWeb.ConnCase

  alias Relix.Recipe

  @create_attrs %{"id" => "A", "value" => "B"}

  setup %{conn: conn} do
    start_supervised(Relix.RecipeStore.InMemoryStore)
    Application.put_env(:relix, :recipe_store, Relix.RecipeStore.InMemoryStore)

    {:ok, recipe} = Recipe.new(1, "A", "B", %{"1" => "2"})
    Relix.RecipeStore.InMemoryStore.insert(recipe)

    {:ok, conn: put_req_header(conn, "accept", "application/json"), recipe: recipe}
  end

  describe "index" do
    test "lists all recipe items", %{conn: conn, recipe: %Recipe{id: recipe_id}} do
      conn = get(conn, Routes.recipe_recipe_item_path(conn, :index, recipe_id))

      assert json_response(conn, 200)["data"] == [
               %{
                 "id" => "1",
                 "value" => "2"
               }
             ]
    end
  end

  describe "create recipe item" do
    test "renders recipe item when data is valid", %{conn: conn, recipe: %Recipe{id: recipe_id}} do
      conn = post(conn, Routes.recipe_recipe_item_path(conn, :create, recipe_id), @create_attrs)
      assert @create_attrs = json_response(conn, 201)["data"]

      conn =
        get(conn, Routes.recipe_recipe_item_path(conn, :show, recipe_id, @create_attrs["id"]))

      assert @create_attrs = json_response(conn, 200)["data"]
    end
  end

  describe "update recipe item" do
    test "renders recipe item when data is valid", %{conn: conn, recipe: %Recipe{id: recipe_id}} do
      conn = put(conn, Routes.recipe_recipe_item_path(conn, :update, recipe_id, "1"), value: "42")
      assert response(conn, 204)

      conn = get(conn, Routes.recipe_recipe_item_path(conn, :show, recipe_id, "1"))

      assert %{
               "id" => "1",
               "value" => "42"
             } = json_response(conn, 200)["data"]
    end
  end

  describe "delete recipe item" do
    test "deletes chosen recipe item", %{conn: conn, recipe: %Recipe{id: recipe_id}} do
      conn = delete(conn, Routes.recipe_recipe_item_path(conn, :delete, recipe_id, "1"))
      assert response(conn, 204)

      conn = get(conn, Routes.recipe_recipe_item_path(conn, :show, recipe_id, "1"))
      assert response(conn, 404)
    end
  end
end
