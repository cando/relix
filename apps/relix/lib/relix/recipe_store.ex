defmodule Relix.RecipeStore do
  @moduledoc false

  @behaviour Relix.RecipeStore.Behaviour

  @impl Relix.RecipeStore.Behaviour
  @spec insert(recipe :: Relix.Recipe.t()) :: {:ok, Relix.Recipe.t()} | {:error, any()}
  def insert(recipe) do
    impl().insert(recipe)
  end

  @impl Relix.RecipeStore.Behaviour
  @spec update(recipe :: Relix.Recipe.t()) :: {:ok, Relix.Recipe.t()} | {:error, any()}
  def update(recipe) do
    impl().update(recipe)
  end

  @impl Relix.RecipeStore.Behaviour
  @spec get_next_identity :: any()
  def get_next_identity() do
    impl().get_next_identity()
  end

  @impl Relix.RecipeStore.Behaviour
  def get_recipe_by_id(id) do
    impl().get_recipe_by_id(id)
  end

  @impl Relix.RecipeStore.Behaviour
  @spec get_recipes() :: [Relix.Recipe.t()]
  def get_recipes() do
    impl().get_recipes()
  end

  @impl Relix.RecipeStore.Behaviour
  @spec delete_by_id(id :: any()) :: :ok | {:error, any()}
  def delete_by_id(id) do
    impl().delete_by_id(id)
  end

  defp impl() do
    Application.get_env(:relix, :recipe_store)
  end
end
