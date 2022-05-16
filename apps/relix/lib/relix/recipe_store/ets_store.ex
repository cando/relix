defmodule Relix.RecipeStore.EtsStore do
  @moduledoc false

  @behaviour Relix.RecipeStore.Behaviour
  use GenServer

  @counter_key :id_counter

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, nil, name: name)
  end

  @impl GenServer
  def init(_) do
    :ets.new(__MODULE__, [:named_table, :public])
    :ets.insert(__MODULE__, {@counter_key, 1})
    {:ok, nil}
  end

  @impl Relix.RecipeStore.Behaviour
  @spec insert(recipe :: Relix.Recipe.t()) :: {:ok, Relix.Recipe.t()} | {:error, any()}
  def insert(recipe) do
    :ets.insert(__MODULE__, {recipe.id, recipe})
    {:ok, recipe}
  end

  @impl Relix.RecipeStore.Behaviour
  @spec update(recipe :: Relix.Recipe.t()) :: {:ok, Relix.Recipe.t()} | {:error, any()}
  def update(recipe) do
    id = recipe.id

    case :ets.lookup(__MODULE__, id) do
      [{^id, _recipe_found}] ->
        insert(recipe)

      [] ->
        {:error, :not_found}
    end
  end

  @impl Relix.RecipeStore.Behaviour
  @spec get_next_identity :: any()
  def get_next_identity() do
    :ets.update_counter(__MODULE__, @counter_key, {2, 1})
  end

  @impl Relix.RecipeStore.Behaviour
  def get_recipe_by_id(id) when is_binary(id), do: get_recipe_by_id(String.to_integer(id))

  def get_recipe_by_id(id) do
    case :ets.lookup(__MODULE__, id) do
      [{^id, recipe}] ->
        {:ok, recipe}

      [] ->
        {:error, :not_found}
    end
  end

  @impl Relix.RecipeStore.Behaviour
  @spec get_recipes() :: [Relix.Recipe.t()]
  def get_recipes() do
    :ets.tab2list(__MODULE__)
    |> Stream.filter(fn {k, _v} -> k != @counter_key end)
    |> Stream.map(fn {_k, v} -> v end)
    |> Enum.into([])
  end

  @impl Relix.RecipeStore.Behaviour
  @spec delete_by_id(id :: any()) :: :ok | {:error, any()}
  def delete_by_id(id) when is_binary(id), do: delete_by_id(String.to_integer(id))

  def delete_by_id(id) do
    case :ets.lookup(__MODULE__, id) do
      [{^id, _recipe}] ->
        :ets.delete(__MODULE__, id)
        :ok

      [] ->
        {:error, :not_found}
    end
  end
end
