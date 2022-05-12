defmodule RelixWeb.RecipeControllerTest do
  use RelixWeb.ConnCase

  alias Relix.Recipe

  @create_attrs %{"name" => "A", "type" => "B"}
  @invalid_attrs %{"name" => nil, "type" => nil}

  setup %{conn: conn} do
    start_supervised(Relix.RecipeStore.InMemoryStore)
    Application.put_env(:relix, :recipe_store, Relix.RecipeStore.InMemoryStore)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all recipes", %{conn: conn} do
      conn = get(conn, Routes.recipe_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create recipe" do
    test "renders recipe when data is valid", %{conn: conn} do
      conn = post(conn, Routes.recipe_path(conn, :create), @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.recipe_path(conn, :show, id))

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.recipe_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update recipe" do
    setup [:create_recipe]

    test "renders recipe when data is valid", %{conn: conn, recipe: %Recipe{id: id} = recipe} do
      conn = put(conn, Routes.recipe_path(conn, :update, recipe), name: "new name")
      assert response(conn, 204)

      conn = get(conn, Routes.recipe_path(conn, :show, id))

      assert %{
               "name" => "new name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, recipe: recipe} do
      conn = put(conn, Routes.recipe_path(conn, :update, recipe), state: :approved)
      assert response(conn, 403)
    end
  end

  describe "delete recipe" do
    setup [:create_recipe]

    test "deletes chosen recipe", %{conn: conn, recipe: recipe} do
      conn = delete(conn, Routes.recipe_path(conn, :delete, recipe))
      assert response(conn, 204)

      conn = get(conn, Routes.recipe_path(conn, :show, recipe))
      assert response(conn, 404)
    end
  end

  defp create_recipe(_) do
    {:ok, recipe} = Recipe.new(1, "A", "B", %{"1" => "2"})
    Relix.RecipeStore.InMemoryStore.insert(recipe)
    %{recipe: recipe}
  end
end
