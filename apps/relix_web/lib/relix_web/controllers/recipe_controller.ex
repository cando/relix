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
    with {:ok, %Recipe{} = recipe} <-
           RecipeList.new_recipe(name, type) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.recipe_path(conn, :show, recipe))
      |> render("show.json", recipe: recipe)
    end
  end

  def show(conn, %{"id" => id}) do
    # TODO
    case RecipeList.get_recipe_by_id(id) do
      :not_found -> render("error.json")
      %Recipe{} = recipe -> render(conn, "show.json", recipe: recipe)
    end
  end

  def update(conn, %{"id" => id, "recipe" => recipe_params}) do
    # TODO
    send_resp(conn, :no_content, "TODO")
  end

  def delete(conn, %{"id" => id}) do
    with :ok <- RecipeList.delete_recipe(id) do
      send_resp(conn, :no_content, "")
    end
  end
end
