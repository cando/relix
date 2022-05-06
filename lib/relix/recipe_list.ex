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

  def get(recipe_list, recipe_id) do
    GenServer.call(recipe_list, {:get, recipe_id})
  end

  def update(recipe_list, recipe_id, new_recipe) do
    GenServer.call(recipe_list, {:update, {recipe_id, new_recipe}})
  end

  def get_recipes(recipe_list) do
    GenServer.call(recipe_list, :get_all)
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
  def handle_call(:get_all, _, {_, recipes} = state), do: {:reply, recipes |> Map.values(), state}

  @impl GenServer
  def handle_call({:get, recipe_id}, _, {_, recipes} = state), do: {:reply, Map.get(recipes, recipe_id, :not_found), state}

  @impl GenServer
  def handle_call({:update, {recipe_id, new_recipe}}, _, {id, recipes} = state) do
    case Map.fetch(recipes, recipe_id) do
      {:ok, _} -> {:reply, :ok, {id, Map.put(recipes, recipe_id, %Recipe{new_recipe | id: recipe_id})}}
      _ -> {:reply, :not_found, state}
    end
  end
end
