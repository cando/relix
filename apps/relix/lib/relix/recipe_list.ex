defmodule Relix.RecipeList do
  use Supervisor

  alias Relix.Recipe
  alias Relix.RecipeStore

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      RecipeStore
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @spec new_recipe(String.t(), String.t(), map) ::
          {:error, :validation_error} | {:ok, Relix.Recipe.t()}
  def new_recipe(name, type, items \\ %{}) do
    new_id = RecipeStore.get_next_identity()

    with {:ok, new_recipe} <- Recipe.new(new_id, name, type, items),
         {:ok, db_recipe} <- RecipeStore.insert(new_recipe) do
      {:ok, db_recipe}
    end
  end

  @spec get_recipe_by_id(any()) :: %Recipe{} | :not_found
  def get_recipe_by_id(recipe_id) do
    RecipeStore.get_recipe_by_id(recipe_id)
  end

  @spec get_recipes :: [%Recipe{}]
  def get_recipes() do
    RecipeStore.get_recipes()
  end

  @spec delete_recipe(any) :: :ok
  def delete_recipe(recipe_id) do
    case get_recipe_by_id(recipe_id) do
      :not_found -> :not_found
      _ -> RecipeStore.delete_by_id(recipe_id)
    end
  end

  @spec rename_recipe(any(), String.t()) :: {:ok, %Recipe{}} | {:error, :not_found}
  def rename_recipe(recipe_id, new_name) do
    case get_recipe_by_id(recipe_id) do
      :not_found -> {:error, :not_found}
      recipe -> RecipeStore.update(%Recipe{recipe | name: new_name})
    end
  end

  @spec add_or_update_item(any(), String.t(), String.t()) :: {:ok, %Recipe{}} | {:error, any()}
  def add_or_update_item(recipe_id, item_key, item_value) do
    case get_recipe_by_id(recipe_id) do
      :not_found ->
        {:error, :not_found}

      recipe ->
        Relix.Recipe.add_or_update_item(recipe, item_key, item_value)
        |> RecipeStore.update()
    end
  end

  @spec delete_item(any(), String.t()) :: {:ok, %Recipe{}} | {:error, any()}
  def delete_item(recipe_id, item_key) do
    case get_recipe_by_id(recipe_id) do
      :not_found ->
        {:error, :not_found}

      recipe ->
        Relix.Recipe.delete_item(recipe, item_key)
        |> RecipeStore.update()
    end
  end
end
