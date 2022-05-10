defmodule Relix.RecipeList do
  alias Relix.Recipe

  @spec new_recipe(String.t(), String.t(), map) ::
          {:error, :validation_error} | {:ok, Relix.Recipe.t()}
  def new_recipe(name, type, items) do
    store = get_recipe_store()
    new_id = store.get_next_identity()

    with {:ok, new_recipe} <- Recipe.new(new_id, name, type, items),
         {:ok, db_recipe} <- store.save(new_recipe) do
      {:ok, db_recipe}
    end
  end

  @spec delete_recipe(any) :: :ok
  def delete_recipe(recipe_id) do
    case get_recipe_by_id(recipe_id) do
      :not_found -> :not_found
      _ -> get_recipe_store().delete_by_id(recipe_id)
    end
  end

  @spec get_recipe_by_id(any()) :: %Recipe{} | :not_found
  def get_recipe_by_id(recipe_id) do
    get_recipes()
    |> Enum.filter(&(&1.id == recipe_id))
    |> List.first(:not_found)
  end

  @spec update_recipe(%Recipe{}) :: :ok | :not_found
  def update_recipe(recipe) do
    case get_recipe_by_id(recipe.id) do
      :not_found -> :not_found
      _ -> get_recipe_store().save(recipe)
    end
  end

  @spec get_recipes :: [%Recipe{}]
  def get_recipes() do
    get_recipe_store().get_recipes()
  end

  defp get_recipe_store() do
    Application.get_env(:relix, :recipe_repo)
  end
end
