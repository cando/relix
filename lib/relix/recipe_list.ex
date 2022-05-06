defmodule Relix.RecipeList do
  use GenServer

  alias Relix.Recipe

  def start_link(identifier) do
    GenServer.start_link(__MODULE__, identifier)
  end

  def new(recipe_list, name, type, items) do
    GenServer.call(recipe_list, {:new, {name, type, items}})
  end

  def delete(recipe_list, id) do
    GenServer.call(recipe_list, {:delete, id})
  end

  def get_recipes(recipe_list) do
    GenServer.call(recipe_list, :get)
  end

  @impl GenServer
  @spec init(any) :: {:ok, {integer(), map}}
  def init(_identifier) do
    {:ok, {1, %{}}}
  end

  @impl GenServer
  def handle_call({:new, {name, type, items}}, _, {id, recipes} = state) do
    case Recipe.new(name, type, items) do
      {:ok, new_recipe} ->
        new_with_id = %Recipe{new_recipe | id: id}
        {:reply, new_with_id, {id + 1, Map.put(recipes, id, new_with_id)}}

      {:error, error} ->
        {:reply, error, state}
    end
  end

  @impl GenServer
  def handle_call({:delete, recipe_id}, _, {id, recipes} = state) do
    case Map.fetch(recipes, recipe_id) do
      {:ok, found_recipe} -> {:reply, :ok, {id, Map.delete(recipes, found_recipe.id)}}
      _ -> {:reply, :not_found, state}
    end
  end

  @impl GenServer
  def handle_call(:get, _, {_, recipes} = state), do: {:reply, recipes |> Map.values(), state}
end
