defmodule RelixWeb.RecipeItemController do
  use RelixWeb, :controller

  alias Relix.RecipeList

  action_fallback(RelixWeb.FallbackController)

  def index(conn, %{"recipe_id" => recipe_id}) do
    with {:ok, recipe} <- RecipeList.get_recipe_by_id(recipe_id) do
      render(conn, "index.json", recipe_items: recipe.items)
    end
  end

  def create(conn, %{"recipe_id" => recipe_id, "id" => name, "value" => value}) do
    with {:ok, updated_recipe} <- RecipeList.add_or_update_item(recipe_id, name, value) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.recipe_recipe_item_path(conn, :show, recipe_id, name))
      |> render("show.json", recipe_item: {name, Map.get(updated_recipe.items, name)})
    end
  end

  def show(conn, %{"recipe_id" => recipe_id, "id" => name}) do
    with {:ok, recipe} <- RecipeList.get_recipe_by_id(recipe_id),
         {:ok, value} <- Map.fetch(recipe.items, name) do
      render(conn, "show.json", recipe_item: {name, value})
    else
      :error -> {:error, :not_found}
      rest -> rest
    end
  end

  def update(conn, %{"recipe_id" => recipe_id, "id" => name, "value" => value}) do
    with {:ok, _updated_recipe} <- RecipeList.add_or_update_item(recipe_id, name, value) do
      send_resp(conn, :no_content, "")
    end
  end

  def delete(conn, %{"recipe_id" => recipe_id, "id" => name}) do
    with {:ok, _updated_recipe} <- RecipeList.delete_item(recipe_id, name) do
      send_resp(conn, :no_content, "")
    end
  end
end
