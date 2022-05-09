defmodule Relix.RecipeList do
  alias Relix.Recipe

  @spec new(String.t(), String.t(), map) :: {:error, :validation_error} | {:ok, Relix.Recipe.t()}
  def new(name, type, items) do
    repo = get_recipe_repository()
    new_id = repo.get_next_identity()

    case Recipe.new(new_id, name, type, items) do
      {:ok, new_recipe} ->
        :ok = repo.save(new_recipe)
        {:ok, new_recipe}

      {:error, error} ->
        {:error, error}
    end
  end

  @spec delete(any) :: :ok
  def delete(recipe_id) do
    case get_by_id(recipe_id) do
      :not_found -> :not_found
      _ -> get_recipe_repository().delete_by_id(recipe_id)
    end
  end

  @spec get_by_id(any()) :: %Recipe{} | :not_found
  def get_by_id(recipe_id) do
    get_recipes()
    |> Enum.filter(&(&1.id == recipe_id))
    |> List.first(:not_found)
  end

  def update(recipe) do
    case get_by_id(recipe.id) do
      :not_found -> :not_found
      _ -> get_recipe_repository().update(recipe)
    end
  end

  @spec get_recipes :: [%Recipe{}]
  def get_recipes() do
    get_recipe_repository().get_recipes()
  end

  defp get_recipe_repository() do
    Application.get_env(:relix, :recipe_repo)
  end
end
