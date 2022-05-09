defmodule Relix.StubRecipeStore do
  @behaviour Relix.RecipeStore.Behaviour

  @impl Relix.RecipeStore.Behaviour
  @spec get_recipes :: [Relix.Recipe.t()]
  def get_recipes() do
    [
      %Relix.Recipe{
        id: 1,
        name: "Recipe1",
        type: "RECIPE",
        state: :draft,
        version: 1,
        items: %{1 => 2}
      }
    ]
  end

  @impl Relix.RecipeStore.Behaviour
  def save(_recipe) do
    :ok
  end

  @impl Relix.RecipeStore.Behaviour
  def update(_recipe) do
    :ok
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
