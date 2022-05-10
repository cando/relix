defmodule Relix.StubRecipeStore do
  @behaviour Relix.RecipeStore.Behaviour

  @impl Relix.RecipeStore.Behaviour
  @spec get_recipes :: [Relix.Recipe.t()]
  def get_recipes() do
    []
  end

  @impl Relix.RecipeStore.Behaviour
  def save(recipe) do
    {:ok, recipe}
  end

  @impl Relix.RecipeStore.Behaviour
  def get_recipe_by_id(_id) do
    %Relix.Recipe{}
  end

  @impl Relix.RecipeStore.Behaviour
  def get_next_identity() do
    1
  end

  @impl Relix.RecipeStore.Behaviour
  def delete_by_id(_id) do
    :ok
  end
end
