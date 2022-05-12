defmodule Relix.RecipeStore.InMemoryStore do
  @moduledoc false

  @behaviour Relix.RecipeStore.Behaviour
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> {0, %{}} end, name: __MODULE__)
  end

  @impl Relix.RecipeStore.Behaviour
  @spec insert(recipe :: Relix.Recipe.t()) :: {:ok, Relix.Recipe.t()} | {:error, any()}
  def insert(recipe) do
    :ok = Agent.update(__MODULE__, fn {id, map} -> {id, Map.put(map, recipe.id, recipe)} end)
    {:ok, recipe}
  end

  @impl Relix.RecipeStore.Behaviour
  @spec update(recipe :: Relix.Recipe.t()) :: {:ok, Relix.Recipe.t()} | {:error, any()}
  def update(recipe) do
    Agent.get_and_update(__MODULE__, fn {id, map} ->
      case Map.has_key?(map, recipe.id) do
        true -> {{:ok, recipe}, {id, Map.put(map, recipe.id, recipe)}}
        false -> {{:error, :not_found}, {id, map}}
      end
    end)
  end

  @impl Relix.RecipeStore.Behaviour
  @spec get_next_identity :: any()
  def get_next_identity() do
    Agent.get_and_update(__MODULE__, fn {id, map} -> {id + 1, {id + 1, map}} end)
  end

  @impl Relix.RecipeStore.Behaviour
  def get_recipe_by_id(id) when is_binary(id), do: get_recipe_by_id(String.to_integer(id))

  def get_recipe_by_id(id) do
    Agent.get(__MODULE__, fn {_, map} ->
      case Map.has_key?(map, id) do
        true -> {:ok, Map.get(map, id)}
        false -> {:error, :not_found}
      end
    end)
  end

  @impl Relix.RecipeStore.Behaviour
  @spec get_recipes() :: [Relix.Recipe.t()]
  def get_recipes() do
    Agent.get(__MODULE__, fn {_id, map} -> Map.values(map) end)
  end

  @impl Relix.RecipeStore.Behaviour
  @spec delete_by_id(id :: any()) :: :ok | {:error, any()}
  def delete_by_id(id) when is_binary(id), do: delete_by_id(String.to_integer(id))

  def delete_by_id(id) do
    Agent.get_and_update(__MODULE__, fn {id_i, map} ->
      case Map.has_key?(map, id) do
        true -> {:ok, {id_i, Map.delete(map, id)}}
        false -> {{:error, :not_found}, {id_i, map}}
      end
    end)
  end
end
