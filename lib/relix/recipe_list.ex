defmodule Relix.RecipeList do
  alias Relix.Recipe

  @spec new_recipe(String.t(), String.t(), map) ::
          {:error, :validation_error} | {:ok, Relix.Recipe.t()}
  def new_recipe(name, type, items) do
    store = get_recipe_store()
    new_id = store.get_next_identity()

    with {:ok, new_recipe} <- Recipe.new(new_id, name, type, items),
         {:ok, db_recipe} <- store.insert(new_recipe) do
      {:ok, db_recipe}
    end
  end

  @spec get_recipe_by_id(any()) :: %Recipe{} | :not_found
  def get_recipe_by_id(recipe_id) do
    get_recipe_store().get_recipe_by_id(recipe_id)
  end

  @spec get_recipes :: [%Recipe{}]
  def get_recipes() do
    get_recipe_store().get_recipes()
  end

  @spec delete_recipe(any) :: :ok
  def delete_recipe(recipe_id) do
    case get_recipe_by_id(recipe_id) do
      :not_found -> :not_found
      _ -> get_recipe_store().delete_by_id(recipe_id)
    end
  end

  @spec rename_recipe(any(), String.t()) :: {:ok, %Recipe{}} | {:error, :not_found}
  def rename_recipe(recipe_id, new_name) do
    case get_recipe_by_id(recipe_id) do
      :not_found -> {:error, :not_found}
      recipe -> get_recipe_store().update(%Recipe{recipe | name: new_name})
    end
  end

  defp get_recipe_store() do
    Application.get_env(:relix, :recipe_repo)
  end
end
