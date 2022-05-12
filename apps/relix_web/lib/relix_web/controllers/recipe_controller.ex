defmodule RelixWeb.RecipeController do
  use RelixWeb, :controller

  alias Relix.RecipeList
  alias Relix.Recipe

  action_fallback RelixWeb.FallbackController

  def index(conn, _params) do
    recipes = RecipeList.get_recipes()
    render(conn, "index.json", recipes: recipes)
  end

  def create(conn, %{"name" => name, "type" => type}) do
    with {:ok, %Recipe{} = recipe} <- RecipeList.new_recipe(name, type) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.recipe_path(conn, :show, recipe))
      |> render("show.json", recipe: recipe)
    end
  end

  def approve(conn, %{"recipe_id" => id}) do
    with {:ok, %Recipe{} = recipe} <- RecipeList.approve_recipe(id) do
      render(conn, "show.json", recipe: recipe)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Recipe{} = recipe} <- RecipeList.get_recipe_by_id(id) do
      render(conn, "show.json", recipe: recipe)
    end
  end

  def update(conn, %{"id" => id, "name" => new_recipe_name}) do
    with {:ok, _} <- RecipeList.rename_recipe(id, new_recipe_name) do
      send_resp(conn, :no_content, "")
    end
  end

  def update(conn, _), do: send_resp(conn, :forbidden, "")

  def delete(conn, %{"id" => id}) do
    case RecipeList.delete_recipe(id) do
      :ok -> send_resp(conn, :no_content, "")
      _ -> {:error, :not_found}
    end
  end
end
