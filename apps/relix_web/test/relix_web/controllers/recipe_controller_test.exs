defmodule RelixWeb.RecipeControllerTest do
  import Mox
  use RelixWeb.ConnCase
  setup :verify_on_exit!

  @create_attrs %{"name" => "A", "type" => "B"}
  @invalid_attrs %{"name" => nil, "type" => nil}

  setup_all _ do
    Mox.defmock(Relix.MockRecipeList, for: Relix.RecipeListBehaviour)
    Application.put_env(:relix, :recipe_list, Relix.MockRecipeList)
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all recipes", %{conn: conn} do
      Relix.MockRecipeList
      |> expect(:get_recipes, 1, fn -> [] end)

      conn = get(conn, Routes.recipe_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create recipe" do
    test "renders recipe when data is valid", %{conn: conn} do
      Relix.MockRecipeList
      |> expect(:new_recipe, 1, fn n, t, i ->
        {:ok, %Relix.Recipe{id: 1, name: n, type: t, items: i}}
      end)
      |> expect(:get_recipe_by_id, 1, fn _ ->
        {:ok, %Relix.Recipe{id: 1}}
      end)

      conn = post(conn, Routes.recipe_path(conn, :create), @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.recipe_path(conn, :show, id))

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      Relix.MockRecipeList
      |> expect(:new_recipe, 1, fn _n, _t, _i -> {:error, :validation_error} end)

      conn = post(conn, Routes.recipe_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "approve recipe" do
    test "approve recipe when data is valid", %{conn: conn} do
      Relix.MockRecipeList
      |> expect(:approve_recipe, 1, fn _i ->
        {:ok, %Relix.Recipe{id: 1, state: :approved}}
      end)
      |> expect(:get_recipe_by_id, 1, fn _ ->
        {:ok, %Relix.Recipe{id: 1, state: :approved}}
      end)

      conn =
        post(conn, Routes.recipe_recipe_path(conn, :approve, %Relix.Recipe{id: 1, state: :draft}))

      assert response(conn, 200)

      conn = get(conn, Routes.recipe_path(conn, :show, 1))

      assert %{
               "state" => "approved"
             } = json_response(conn, 200)["data"]
    end
  end

  describe "update recipe" do
    test "renders recipe when data is valid", %{conn: conn} do
      new_name = "new name"

      Relix.MockRecipeList
      |> expect(:rename_recipe, 1, fn _i, _new_name ->
        {:ok, %Relix.Recipe{id: 1, name: new_name}}
      end)
      |> expect(:get_recipe_by_id, 1, fn _ ->
        {:ok, %Relix.Recipe{id: 1, name: new_name}}
      end)

      conn =
        put(conn, Routes.recipe_path(conn, :update, %Relix.Recipe{id: 1, name: "old"}),
          name: new_name
        )

      assert response(conn, 204)

      conn = get(conn, Routes.recipe_path(conn, :show, 1))

      assert %{
               "name" => ^new_name
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        put(conn, Routes.recipe_path(conn, :update, %Relix.Recipe{id: 1, name: "old"}),
          state: :approved
        )

      assert response(conn, 403)
    end
  end

  describe "delete recipe" do
    test "deletes chosen recipe", %{conn: conn} do
      Relix.MockRecipeList
      |> expect(:delete_recipe, 1, fn _i -> :ok end)
      |> expect(:get_recipe_by_id, 1, fn _ -> {:error, :not_found} end)

      conn = delete(conn, Routes.recipe_path(conn, :delete, %Relix.Recipe{id: 1}))
      assert response(conn, 204)

      conn = get(conn, Routes.recipe_path(conn, :show, %Relix.Recipe{id: 1}))
      assert response(conn, 404)
    end
  end
end
