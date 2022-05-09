defmodule Relix.RecipeList do
  use Supervisor

  alias Relix.Recipe

  @spec new_recipe(String.t(), String.t(), map) ::
          {:error, :validation_error} | {:ok, Relix.Recipe.t()}
  def new_recipe(name, type, items) do
    store = get_recipe_store()
    new_id = store.get_next_identity()

    case Recipe.new(new_id, name, type, items) do
      {:ok, new_recipe} ->
        :ok = store.save(new_recipe)
        {:ok, new_recipe}

      {:error, error} ->
        {:error, error}
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
      _ -> get_recipe_store().update(recipe)
    end
  end

  @spec get_recipes :: [%Recipe{}]
  def get_recipes() do
    get_recipe_store().get_recipes()
  end

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do

    children = if Mix.env() == :test,
      do: [],
      else: [
        Relix.RecipeStore.Supervisor
      ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp get_recipe_store() do
    Application.get_env(:relix, :recipe_repo)
  end
end
